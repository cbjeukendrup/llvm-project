//===-- Passes.td - TOSA pass declarations ----*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file declares the passes for the TOSA Dialect in MLIR.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_TOSA_TRANSFORMS_PASSES
#define MLIR_DIALECT_TOSA_TRANSFORMS_PASSES

include "mlir/Pass/PassBase.td"

def TosaInferShapes : FunctionPass<"tosa-infer-shapes"> {
  let summary = "Propagate shapes across TOSA operations";
  let description = [{
    Pass that uses operand types and propagates shapes to TOSA operations.
    This includes legalizing rankless and dynamic shapes towards static.
  }];

  let constructor = "createTosaInferShapesPass()";
  let dependentDialects = [
    "StandardOpsDialect",
    "tensor::TensorDialect",
    "tosa::TosaDialect",
  ];
}

def TosaMakeBroadcastable : FunctionPass<"tosa-make-broadcastable"> {
  let summary = "TOSA rank Reshape to enable Broadcasting";
  let description = [{
    Pass that enables broadcast by making all input arrays have the same
    number of dimensions. Insert RESHAPE operations to prepend dimensions
    of size one until the number of dimensions is equal. Implements
    approach similar to step 1 of Numpy 4-step broadcasting:
    https://numpy.org/doc/stable/reference/ufuncs.html#broadcasting
  }];

  let constructor = "createTosaMakeBroadcastablePass()";
}

def TosaOptionalDecompositions : FunctionPass<"tosa-optional-decompositions"> {
  let summary = "Applies Tosa operations optional decompositions";
  let description = [{
    Pass to apply the Tosa operations decompositions 
    exposed as populate functions in include/mlir/Dialect/Tosa/Transforms/Passes.h
  }];

  let constructor = "tosa::createTosaOptionalDecompositions()";
}

#endif // MLIR_DIALECT_TOSA_TRANSFORMS_PASSES
