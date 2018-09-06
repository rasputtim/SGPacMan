#ifndef _SGF_network_cacher_h
#define _SGF_network_cacher_h

#include "level/cacher.h"

class NetworkCacher: public Level::Cacher {
public:
    NetworkCacher();
    
    virtual Paintown::Object * cache(const BlockObject & block) const;

    virtual ~NetworkCacher();
};

#endif
