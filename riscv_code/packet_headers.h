
#define ETH_ALEN 6

struct eth_header {
    unsigned char dest_mac[ETH_ALEN];
    unsigned char src_mac[ETH_ALEN];
    unsigned short type;
};

#define ETH_HEADER_SIZE sizeof(struct eth_header)

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

#define IPV4_HEADER_SIZE sizeof(struct ipv4_header)

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

#define TCP_HEADER_SIZE sizeof(struct tcp_header)

struct udp_header {
    unsigned short src_port;
    unsigned short dest_port;
    unsigned short length;
    unsigned short checksum;
};

#define UDP_HEADER_SIZE sizeof(struct udp_header)

