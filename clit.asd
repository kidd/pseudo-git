#|
  This file is a part of clit project.
  Copyright (c) 2017 Raimon Grau (raimonster@gmail.com)
|#

#|
  Author: Raimon Grau (raimonster@gmail.com)
|#

(in-package :cl-user)
(defpackage clit-asd
  (:use :cl :asdf))
(in-package :clit-asd)

(setq *load-path* #P"/home/rgrau/programmingStuff/clit/")

(asdf:defsystem clit
  :version "0.1"
  :author "Raimon Grau"
  :license "LLGPL"
  :depends-on (cl-fad alexandria ironclad salza2 arnesi pack)
  :components ((:module "src"
                :components
                ((:file "clit"))))
  :description "")
