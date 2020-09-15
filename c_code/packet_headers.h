
struct eth_header {
    unsigned char dest_mac[6];
    unsigned char src_mac[6];
    unsigned short type;
};

struct ipv4_header {
    unsigned char version_ihl;
    unsigned char dscp_ecn;
    unsigned short total_length;
    unsigned short id;
    unsigned short flags_fragment_offset;
    unsigned char ttl;
    unsigned char protocol;
    unsigned short hdr_sum;
    unsigned long src_ip;
    unsigned long dest_ip;
};

struct tcp_header {
    unsigned short src_port;
    unsigned short dest_port;
    unsigned long seq;
    unsigned long ack;
    unsigned short flags;
    unsigned short window;
    unsigned short checksum;
    unsigned short urgent_ptr;
};

struct udp_header {
    unsigned short src_port;
    unsigned short dest_port;
    unsigned short length;
    unsigned short checksum;
};

