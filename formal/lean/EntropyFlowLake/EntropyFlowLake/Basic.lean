namespace EntropyFlowLake

/-!
Offline-friendly formal spin (no Mathlib):

- `FinSupp`: naive finite-support container (List-based)
- `Weight`: coefficient assignment
- `partitionSum`: syntactic placeholder for a finite sum over support
- This file is intended to compile in a fresh Lean toolchain with no extra dependencies.
-/

structure FinSupp (α : Type) where
  support : List α

/-- A "weight" assigns a coefficient to each state. --/
abbrev Weight (α : Type) (R : Type) := α → R

/-- Placeholder: a partition sum over a finite support list. --/
def partitionSum {α R : Type} (fs : FinSupp α) (w : Weight α R)
    (add : R → R → R) (zero : R) : R :=
  fs.support.foldl (fun acc a => add acc (w a)) zero

def hello : String := "EntropyFlowLake: initialized (offline, no Mathlib)."

end EntropyFlowLake
