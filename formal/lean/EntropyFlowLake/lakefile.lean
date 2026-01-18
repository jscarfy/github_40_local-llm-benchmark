import Lake
open Lake DSL

package EntropyFlowLake where
  moreServerOptions := #[]
  moreLeanArgs := #[]

lean_lib EntropyFlowLake where
  roots := #[`EntropyFlowLake]
