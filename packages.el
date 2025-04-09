;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(package! autothemer)

(package! copilot
 :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el")))
