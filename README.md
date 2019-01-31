# Devops Starter Kit

A collection of re-usable terraform modules for common project tasks with an emphasis on AWS and EKS

## Organization

I've organized the modules in this repository following a methodology similar to [Brad Frost's Atomic Design](http://bradfrost.com/blog/post/atomic-web-design/). The goal
of this choice is to seperate out modules based on the number of dependencies they
include as well as the number of services that they touch.

### Atoms

Modules in the 'atoms' directory should create a single terraform resource. These
are useful for creating resources that have lots of inputs that are usually the same,
atoms can be used to set reasonable defaults. Atom modules must not use no more than 1 provider.

### Molecules

Molecules are made up of more than one atom or resource, or are extended special
cases of atoms. They must not use more than one provider.

### Organisms

Organisms are higher level beasts, they can be made up of multiple atoms, molecules
and/or resources and they are allowed to use multiple providers to accomplish this.
