// MAPS - Memory Access Pattern Specification Framework
// http://maps-gpu.github.io/
// Copyright (c) 2015, A. Barak
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
// * Neither the names of the copyright holders nor the names of its 
//   contributors may be used to endorse or promote products derived from this
//   software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

// This file contains various preprocessor definitions to assist multi-GPU 
// programming with MAPS.
// This file also acts as an all-inclusive header for the library.

#ifndef __MAPS_MULTI_CUH
#define __MAPS_MULTI_CUH

#include <cuda_runtime.h>  // dim3
#include <iostream>

#include "../internal/common.cuh" // MAPS_INIT
#include "scheduler.h"
#include "task_graph.h"
#include "aggregators.h"
#include "pinned_allocation.h"

namespace maps
{
    namespace multi
    {        
        #define MAPS_MULTIDEF(...) (unsigned int deviceIdx, dim3 multigridDim, uint3 blockIdx, ##__VA_ARGS__)
        #define MAPS_MULTIDEF2 unsigned int deviceIdx, dim3 multigridDim, uint3 blockIdx

        #if __CUDA_ARCH__
            #define MAPS_MULTI_INIT()   do { unsigned int __realBlockIdx;                                            \
                                            asm("mov.b32   %0, %ctaid.x;" : "=r"(__realBlockIdx));                    \
                                            ::maps::multi::GlobalBlockIdx(blockIdx, __realBlockIdx, multigridDim);    \
                                        } while(0)
        #else
            #define MAPS_MULTI_INIT()
        #endif        

        /// @brief Initializes a list of containers simultaneously and prepares them for multi-GPU processing.
        #define MAPS_MULTI_INITVARS(...)  MAPS_MULTI_INIT(); MAPS_INIT(__VA_ARGS__)

    } // namespace multi

} // namespace maps

#endif // __MAPS_MULTI_CUH
