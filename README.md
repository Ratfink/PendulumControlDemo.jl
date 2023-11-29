# PendulumControlDemo

[![Build Status](https://github.com/Ratfink/PendulumControlDemo.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/Ratfink/PendulumControlDemo.jl/actions/workflows/CI.yml?query=branch%3Amain)

An interactive demo of pendulum control in Julia.

## Installation

First, install Julia from [the Julia website](https://julialang.org/downloads/).
The latest stable version as of this writing is Julia 1.9.4.

Run the Julia REPL (Read, Execute, Print Loop).  How this is done depends on
your OS and how you installed the language.  From the Julia REPL, run:

```julia
using Pkg
Pkg.add(url="https://github.com/Ratfink/PendulumControlDemo.jl", rev="no-joystick")
```

Thanks to Julia's built-in package manager, this should automatically install
all the dependencies needed to run the demo.

## Usage

Once the demo is installed, you can run it by simply running the following
code snippet.

```julia
using PendulumControlDemo
pendulum_run()
```

A window should appear, running the demo.

## On-line editing

Julia supports on-line code reloading using the
[Revise.jl](https://timholy.github.io/Revise.jl/stable/) package.  To make use
of this package, first install it:

```julia
Pkg.add("Revise")
```

Revise must be loaded prior to any code that will be edited.  Restart the REPL,
then load the Revise package before the demo.

```julia
using Revise, PendulumControlDemo
pendulum_run()
```

Now any edits made to the code can be immediately seen by running the
`pendulum_run()` function again, without having to restart Julia.

## Exercises

* Modify the K_D slider and controller code to use standard form rather than
  parallel form.
* Use the `ControlSystemsBase` package to compute a PD controller for the
  pendulum and rewrite the code to use your controller.
* Add an integral term to the dynamics and try designing a full PID controller.
  How does its response compare to the PD controller?
* Rewrite the dynamics equation of the pendulum to linearize it around
  vertical.  How does your controller's response change?  How do the pendulum's
  open-loop dynamics change?
