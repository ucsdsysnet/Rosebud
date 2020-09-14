#!/usr/bin/env python
"""
Copyright 2020, The Regents of the University of California.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE REGENTS OF THE UNIVERSITY OF CALIFORNIA ''AS
IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE REGENTS OF THE UNIVERSITY OF CALIFORNIA OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies,
either expressed or implied, of The Regents of the University of California.
"""

import argparse
import collections
import os


class AhoCorasickState(object):
    def __init__(self, parent=None, char=None):
        self.char = char
        self.children = {}
        self.match = []
        self.lss = None
        self.index = None
        self.next_index = None

    def get_child(self, ch):
        try:
            return self.children[ch]
        except KeyError:
            s = AhoCorasickState(ch)
            self.children[ch] = s
            return s

    #def __repr__(self):
    #    return '%s(char="%s", match="%s", children=%s)' % (type(self).__name__, self.char, self.match, repr(self.children))

    def __getitem__(self, key):
        return self.children[key]

    def __iter__(self):
        return self.children.__iter__()

    def __len__(self):
        return len(self.children)
        
    def items(self):
        return self.children.items()

    def count(self):
        return len(self.children)


class AhoCorasickStateMachine(object):
    def __init__(self):
        self.root = AhoCorasickState()
        self.states = []
        self.matches = []
        self._finalized = False

    def add_words(self, lst):
        """
        Insert list of words
        """
        for word in lst:
            self.add_word(word)

    def add_word(self, word, value=None):
        """
        Insert single word
        """

        # cannot be called after the object is finalized
        if self._finalized:
            raise Exception("Already finalized")

        if isinstance(word, tuple):
            word, value = word

        match = (len(self.matches), word, value)
        self.matches.append(match)

        # recursively add characters in string to construct a trie
        state = self.root
        for ch in word:
            state = state.get_child(ch)
        state.match.append(match)

    def finalize(self):
        """
        Finalize trie by adding internal longest strict suffix links
        """

        if self._finalized:
            return

        # iterate over nodes with a breadth-first search
        processed = set()
        q = collections.deque()

        # root longest strict suffix is root
        processed.add(id(self.root))
        self.root.index = 0
        self.states = [self.root]
        self.root.lss = self.root

        # start with nodes directly under root
        for ch, node in self.root.items():
            processed.add(id(node))
            q.append(node)

            node.index = len(self.states)
            self.states.append(node)

            # initially, set longest strict suffix to point to root
            node.lss = self.root

        # breadth-first search over remaining nodes
        while q:
            node = q.popleft()
            processed.add(id(node))

            for ch, child in node.items():
                if id(child) in processed:
                    continue

                q.append(child)

                child.index = len(self.states)
                self.states.append(child)

                state = node.lss

                while ch not in state and state != self.root:
                    state = state.lss

                if ch in state:
                    child.lss = state[ch]
                else:
                    child.lss = self.root

                # accumulate matches from suffixes
                if child.lss.match:
                    child.match += child.lss.match

        # fill next states with breadth-first search
        processed = set()
        q = collections.deque()

        # start from root node
        q.append(self.root)

        while q:
            node = q.popleft()
            processed.add(id(node))

            node.next_index = {}

            # add child nodes
            for ch, child in node.items():
                if id(child) in processed:
                    continue

                q.append(child)

                node.next_index[ch] = child.index

            # add all suffixes
            state = node

            while state != self.root:
                state = state.lss
                for ch, child in state.items():
                    if ch not in node.next_index:
                        node.next_index[ch] = child.index

        self._finalized = True

    def query_char(self, state, ch):
        """
        Search string for matches using trie
        """

        # finalize if necessary
        if not self._finalized:
            self.finalize()

        if state is None:
            state = self.root

        while ch not in state and state != self.root:
            state = state.lss

        if ch in state:
            state = state[ch]
            return (state, state.match)
        else:
            return (self.root, None)

    def query(self, s):
        """
        Search string for matches using trie
        """

        # finalize if necessary
        if not self._finalized:
            self.finalize()

        state = self.root

        # loop over input string
        for i, ch in enumerate(s):
            # check all suffixes
            while ch not in state and state != self.root:
                state = state.lss

            if ch in state:
                state = state[ch]
                for m in state.match:
                    yield (i-len(m[1])+1, *m)
            else:
                state = self.root


class BitSplitStateMachine(object):
    def __init__(self, bit_width=8, split_width=1):
        self.bit_width = bit_width
        self.split_width = split_width
        self.split_count = int(bit_width / split_width)
        self.matches = []
        self._finalized = False

        assert self.split_count * self.split_width == self.bit_width

        self.acsm = []

        for k in range(self.split_count):
            self.acsm.append(AhoCorasickStateMachine())

    def add_words(self, lst):
        """
        Insert list of words
        """
        for word in lst:
            self.add_word(word)

    def split_char(self, ch):
        if isinstance(ch, str):
            ch = ch.encode('utf-8')

        if not isinstance(ch, int):
            assert len(ch) == 1
            ch = ch[0]

        return [(ch >> (self.split_width*k)) & (2**self.split_width-1) for k in range(self.split_count)]

    def split_string(self, word):
        if isinstance(word, str):
            word = word.encode('utf-8')

        return [[(ch >> (self.split_width*k)) & (2**self.split_width-1) for ch in word] for k in range(self.split_count)]        

    def add_word(self, word, value=None):
        """
        Insert single word
        """

        # cannot be called after the object is finalized
        if self._finalized:
            raise Exception("Already finalized")

        if isinstance(word, tuple):
            word, value = word

        match = (len(self.matches), word, value)
        self.matches.append(match)

        # bit split input string
        split_word = self.split_string(word)

        for k in range(self.split_count):
           self.acsm[k].add_word(split_word[k], match)

    def finalize(self):
        """
        Finalize trie by adding internal longest strict suffix links
        """

        if self._finalized:
            return

        for sm in self.acsm:
            sm.finalize()

        self._finalized = True

    def query_char(self, state, ch):
        """
        Search string for matches using trie
        """

        # finalize if necessary
        if not self._finalized:
            self.finalize()

        if state is None:
            state = [None]*self.split_count

        ch = self.split_char(ch)

        match = [None]*self.split_count

        for k in range(self.split_count):
            state[k], match[k] = self.acsm[k].query_char(state[k], ch[k])

        match = [[m[2] for m in s] if s is not None else [] for s in match]
        match = list(set(match[0]).intersection(*match))

        return (state, match)

    def query(self, s):
        """
        Search string for matches using trie
        """

        # finalize if necessary
        if not self._finalized:
            self.finalize()

        state = [None]*self.split_count

        # loop over input string
        for i, ch in enumerate(s):
            ch = self.split_char(ch)

            match = [None]*self.split_count

            for k in range(self.split_count):
                state[k], match[k] = self.acsm[k].query_char(state[k], ch[k])

            match = [[m[2] for m in s] if s is not None else [] for s in match]
            match = set(match[0]).intersection(*match)

            for m in match:
                yield (i-len(m[1])+1, *m)

    def to_verilog(self, prefix=None):
        """
        Generate verilog string matching engine core
        """

        # finalize if necessary
        if not self._finalized:
            self.finalize()

        if not prefix:
            prefix = ""
        else:
            prefix += "_"

        sw = self.split_width
        mc = len(self.matches)

        s = ''

        for sm_ind in range(self.split_count):
            sc = len(self.acsm[sm_ind].states)
            clsc = (sc-1).bit_length()

            s += f"// FSM {sm_ind}\n"
            s += f"reg [{clsc-1}:0] {prefix}fsm_{sm_ind}_state_reg;\n"
            s += f"reg [{mc-1}:0] {prefix}fsm_{sm_ind}_match_reg;\n"
            s += f"\n"
            s += f"always @(posedge clk) begin\n"
            s += f"    case ({prefix}fsm_{sm_ind}_state_reg)\n"

            for state_ind in range(sc):
                s += f"        {clsc}'d{state_ind}: begin\n"

                state = self.acsm[sm_ind].states[state_ind]

                match = sum((1 << m[0] for m in state.match))

                s += f"            {prefix}fsm_{sm_ind}_match_reg <= {mc}'b{match:>0{mc}b};\n"
                s += f"            if (s_axis_tvalid) begin\n"
                s += f"                case (s_axis_tdata[{(sm_ind+1)*sw-1}:{sm_ind*sw}])\n"


                for val in range(2**sw):
                    next_state = 0

                    if val in state.next_index:
                        next_state = state.next_index[val]


                    s += f"                    {sw}'b{val:>0{sw}b}: {prefix}fsm_{sm_ind}_state_reg <= {clsc}'d{next_state};\n"

                s += f"                endcase\n"
                s += f"            end\n"
                s += f"        end\n"
            
            s += f"    endcase\n"
            s += f"\n"
            s += f"    if (rst) begin\n"
            s += f"        {prefix}fsm_{sm_ind}_state_reg <= {clsc}'d0;\n"
            s += f"        {prefix}fsm_{sm_ind}_match_reg <= {mc}'d0;\n"
            s += f"    end\n"
            s += f"end\n"
            s += f"\n"

        s += f"assign {prefix}match = "+' & '.join([f'{prefix}fsm_{sm_ind}_match_reg' for sm_ind in range(self.split_count)])+";\n"

        return s

    def to_verilog_module(self, name=None):
        """
        Generate verilog string matching engine module
        """

        # finalize if necessary
        if not self._finalized:
            self.finalize()

        if not name:
            name = "sme"

        s = f"""/*

Copyright 2020, The Regents of the University of California.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE REGENTS OF THE UNIVERSITY OF CALIFORNIA ''AS
IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE REGENTS OF THE UNIVERSITY OF CALIFORNIA OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies,
either expressed or implied, of The Regents of the University of California.

*/

// Language: Verilog 2001

`timescale 1ns / 1ps

/*
 * String matching engine
 */
module {name}
(
    input  wire        clk,
    input  wire        rst,

    /*
     * AXI Stream input
     */
    input  wire [7:0]  s_axis_tdata,
    input  wire        s_axis_tvalid,

    output wire [{mc-1}:0] match
);

"""

        s += self.to_verilog()

        s +="""

endmodule

"""

        return s


class BitSplitStateMachineGroup(object):
    def __init__(self, bit_width=8, split_width=1, max_matches=None, max_states=None):
        self.bit_width = bit_width
        self.split_width = split_width
        self.split_count = int(bit_width / split_width)
        self.max_matches = max_matches
        self.max_states = max_states
        self.matches = []
        self._finalized = False

        assert self.split_count * self.split_width == self.bit_width

        self.bssm = []

    def add_words(self, lst):
        """
        Insert list of words
        """
        for word in lst:
            self.add_word(word)

    def add_word(self, word, value=None):
        """
        Insert single word
        """

        # cannot be called after the object is finalized
        if self._finalized:
            raise Exception("Already finalized")

        if isinstance(word, tuple):
            word, value = word

        match = (len(self.matches), word, value)
        self.matches.append(match)

    def finalize(self):
        """
        Finalize group
        """

        if self._finalized:
            return

        # partition across multiple bit-split state machines
        offset = 0
        count = len(self.matches)

        while count > 0:
            if self.max_matches and count > self.max_matches:
                count = self.max_matches

            bssm = BitSplitStateMachine(self.bit_width, self.split_width)
            for m in self.matches[offset:offset+count]:
                bssm.add_word(m[1], m)
            bssm.finalize()

            if self.max_states and max((len(sm.states) for sm in bssm.acsm)) > self.max_states:
                count -= 1
                if count < 1:
                    raise Exception("Partitioning failed")
                continue

            self.bssm.append(bssm)

            offset += count

            count = len(self.matches) - offset

        self._finalized = True

    def query(self, s):
        """
        Search string for matches using trie
        """

        # finalize if necessary
        if not self._finalized:
            self.finalize()

        state = [None]*len(self.bssm)

        # loop over input string
        for i, ch in enumerate(s):
            match = [None]*len(self.bssm)

            for k in range(len(self.bssm)):
                state[k], match[k] = self.bssm[k].query_char(state[k], ch)

            match = [item[2] for sublist in match for item in sublist]

            for m in match:
                yield (i-len(m[1])+1, *m)

    def to_verilog_module(self, name=None):
        """
        Generate verilog string matching engine module
        """

        # finalize if necessary
        if not self._finalized:
            self.finalize()

        if not name:
            name = "sme"

        sw = self.split_width
        mc = len(self.matches)

        s = f"""/*

Copyright 2020, The Regents of the University of California.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE REGENTS OF THE UNIVERSITY OF CALIFORNIA ''AS
IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE REGENTS OF THE UNIVERSITY OF CALIFORNIA OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies,
either expressed or implied, of The Regents of the University of California.

*/

// Language: Verilog 2001

`timescale 1ns / 1ps

/*
 * String matching engine
 */
module {name}
(
    input  wire        clk,
    input  wire        rst,

    /*
     * AXI Stream input
     */
    input  wire [7:0]  s_axis_tdata,
    input  wire        s_axis_tvalid,

    output wire [{mc-1}:0] match
);

"""

        offset = 0

        for sm_ind in range(len(self.bssm)):
            sm = self.bssm[sm_ind]
            width = len(sm.matches)
            s += f"// Partition {sm_ind}\n"
            s += f"// Matches: {width}\n"
            s += f"wire [{width-1}:0] p{sm_ind}_match;\n"
            s += "\n"
            s += sm.to_verilog(f"p{sm_ind}")
            s += "\n"
            s += f"assign match[{offset+width-1}:{offset}] = p{sm_ind}_match;\n"
            s += "\n"

            offset += width

        s +="""
endmodule

"""

        return s


def parse_content_string(s):
    """
    Parse content string and convert to byte string

    Converts hex sections delineated with pipes

    an example|20|string|0d 0a|

    b'an example string\r\n'

    """
    b = bytearray()
    offset = 0

    while offset < len(s):
        if '|' in s[offset:]:
            rs = s.index('|', offset)
            re = s.index('|', rs+1)

            b.extend(s[offset:rs].encode('utf-8'))
            b.extend(bytearray.fromhex(s[rs+1:re]))

            offset = re+1
        else:
            b.extend(s[offset:].encode('utf-8'))
            break

    return bytes(b)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--split_width', type=int, default=2, help="Bit split width")
    parser.add_argument('--max_matches', type=int, default=None, help="Max matches per block")
    parser.add_argument('--max_states', type=int, default=None, help="Max states per block")

    parser.add_argument('--match_file', type=str, default=[], action='append', help="Match file")
    parser.add_argument('--match_file_hex', type=str, default=[], action='append', help="Match file (hex)")
    parser.add_argument('--rules_file', type=str, default=[], action='append', help="Rules file")
    parser.add_argument('--test_file', type=str, default=None, help="Test file")

    parser.add_argument('--module_name', type=str, default=None, help="Verilog module name")
    parser.add_argument('--output_verilog', type=str, default=None, help="Verilog output file name")

    parser.add_argument('--states_file', type=str, default=None, help="States output file name")

    parser.add_argument('--summary_file', type=str, default=None, help="Summary file")
    parser.add_argument('--stats_file', type=str, default=None, help="Statistics file")

    args = parser.parse_args()

    split_width = args.split_width
    max_matches = args.max_matches
    max_states = args.max_states

    match_list = []

    for fn in args.match_file:
        with open(fn, 'r') as f:
            for w in f.read().splitlines():
                b = w.encode('utf-8')
                if not b:
                    continue
                match_list.append((b, w))

    for fn in args.match_file_hex:
        with open(fn, 'r') as f:
            for w in f.read().splitlines():
                b = bytes.fromhex(w)
                if not b:
                    continue
                match_list.append((b, w))

    for fn in args.rules_file:
        with open(fn, 'r') as f:
            for w in f.read().splitlines():
                b = parse_content_string(w)
                if not b:
                    continue
                match_list.append((b, w))

    match_set = set()
    match_list_filtered = []

    for m in match_list:
        if m[0] not in match_set:
            match_set.add(m[0])
            match_list_filtered.append(m)

    match_list_filtered.sort()

    print("Partition matches across bit-split state machines")
    bssmg = BitSplitStateMachineGroup(8, split_width, max_matches, max_states)

    bssmg.add_words(match_list_filtered)

    bssmg.finalize()

    stats = "Statistics\n"
    stats += "Configuration\n"
    stats += f"Split width: {bssmg.split_width}\n"
    stats += f"Split count: {bssmg.split_count}\n"
    stats += f"Max matches: {bssmg.max_matches}\n"
    stats += f"Max states: {bssmg.max_states}\n"
    stats += "Matches\n"
    stats += f"Input files: {' '.join(args.match_file+args.match_file_hex+args.rules_file)}\n"
    stats += f"Match count: {len(bssmg.matches)}\n"
    stats += f"Shortest match (bytes): {min((len(m[1]) for m in bssmg.matches))}\n"
    stats += f"Longest match (bytes): {max((len(m[1]) for m in bssmg.matches))}\n"
    stats += f"Total match (bytes): {sum((len(m[1]) for m in bssmg.matches))}\n"
    stats += "State Machines\n"
    stats += f"Partition count: {len(bssmg.bssm)}\n"
    stats += f"Total state count: {sum((len(acsm.states) for sm in bssmg.bssm for acsm in sm.acsm))}\n"
    for n in range(len(bssmg.bssm)):
        stats += f"Partition {n} match count: {len(bssmg.bssm[n].matches)}\n"
        stats += f"Partition {n} total state count: {sum((len(acsm.states) for acsm in bssmg.bssm[n].acsm))}\n"
        for k in range(bssmg.split_count):
            stats += f"Partition {n} split {k} state count: {len(bssmg.bssm[n].acsm[k].states)}\n"

    print(stats.strip())

    if args.stats_file:
        with open(args.stats_file, 'w') as f:
            f.write(stats)

    if args.summary_file:
        with open(args.summary_file, 'w') as f:
            f.write("index,partition,bit,hex,match\n")

            l = {}

            for n in range(len(bssmg.bssm)):
                for m in bssmg.bssm[n].matches:
                    bit = m[0]
                    index = m[2][0]

                    l[index] = (n, bit)

            for m in bssmg.matches:
                f.write(f"{m[0]},{l[m[0]][0]},{l[m[0]][1]},{m[1].hex()},\"{m[2]}\"\n")

    if args.output_verilog is not None:
        module_name = args.module_name
        if module_name is None:
            module_name = os.path.splitext(os.path.basename(args.output_verilog))[0]

        print(f"Write verilog module {module_name} to {args.output_verilog}")
        with open(args.output_verilog, 'w') as f:
            f.write(bssmg.to_verilog_module(module_name))

    if args.states_file is not None:
        print(f"Write states file to {args.states_file}")
        with open(args.states_file, 'w') as f:
            f.write(f"partition,split,index,{','.join('next_state_{}'.format(i) for i in range(2**bssmg.split_width))},match\n")

            for n in range(len(bssmg.bssm)):
                for k in range(bssmg.split_count):
                    for s in bssmg.bssm[n].acsm[k].states:
                        partition = n
                        split = k
                        index = s.index

                        next_state = []

                        for i in range(2**bssmg.split_width):
                            if i in s.next_index:
                                next_state.append(str(s.next_index[i]))
                            else:
                                next_state.append("0")

                        m = sum((1 << m[0] for m in s.match))
                        f.write(f"{partition},{split},{index},{','.join(next_state)},{m}\n");

    if args.test_file:
        with open(args.test_file, 'rb') as f:
            print("Query bit-split state machines")
            for m in bssmg.query(f.read()):
                print(m)

if __name__ == "__main__":
    main()

