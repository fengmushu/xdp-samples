# List of programs to build
tprogs-y := xdp_router_ipv4



# List of programs ref source
xdp_router_ipv4-objs := xdp_router_ipv4_user.o



# Tell kbuild to always build the programs
always-y := $(tprogs-y)
always-y += xdp_router_ipv4_kern.o
