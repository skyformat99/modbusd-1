//
// taka-wang
//

#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>
#include <string.h>
#include <time.h>
#include <errno.h>
#include <czmq.h>

#include "modbusd.h"

// Marco
#define VERSION "0.0.1"
#define IPC_SUB "ipc:///tmp/to.modbus"
#define IPC_PUB "ipc:///tmp/from.modbus"
#define DEFAULT_TCP_PORT 502


int init_mbtcp_ctx(const char *ip, int port)
{
    modbus_t *ctx;
    ctx = modbus_new_tcp("127.0.0.1", 1502);
    if (ctx == NULL) {
        fprintf(stderr, "Unable to allocate libmodbus context\n");
        return -1;
    }

    if (modbus_connect(ctx) == -1) {
        fprintf(stderr, "Connection failed: %s\n", modbus_strerror(errno));
        modbus_free(ctx);
        return -1;
    }
}

void get_mbtcp_ctx()
{
    
}


// ENTRY
int main(int argc, char *argv[])
{
    int i = init_mbtcp_ctx("127.0.0.1", 1502);
    // @load external config
    // TODO
    
    // @setup zmq
    zctx_t *zmq_context = zctx_new ();
    // init zmq subscriber: zmq_sub
    void *zmq_sub = zsocket_new (zmq_context, ZMQ_SUB);
    // bind zmq subscriber
    zsocket_bind (zmq_sub, IPC_SUB);
    // set zmq subscriber filter
    zsocket_set_subscribe (zmq_sub, ""); 
    // init zmq publisher: zmq_pub
    void *zmq_pub = zsocket_new (zmq_context, ZMQ_PUB);
    // bind zmq publisher
    zsocket_bind (zmq_pub, IPC_PUB);
    
    // try
    modbus_t *ctx = NULL;
    
    // @start receiving zmq command
    printf("start command listener\n");
    while (!zctx_interrupted) // handle ctrl+c
    {
        zmsg_t *msg = zmsg_recv(zmq_sub);
        if (msg != NULL)
        {
            //zmsg_dump(msg);
        }
    }
    
    // @resource clean up
    printf("clean up\n");
    zctx_destroy(&zmq_context);
    exit(EXIT_SUCCESS);
}