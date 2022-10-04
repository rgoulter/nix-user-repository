{ pkgs
, fenix-pkgs
}:

import ./go { inherit pkgs; } //
import ./python { inherit pkgs; } //
import ./rust { inherit pkgs fenix-pkgs; } //
import ./terraform { inherit pkgs; }
