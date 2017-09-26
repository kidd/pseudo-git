#|
  This file is a part of clit project.
  Copyright (c) 2017 Raimon Grau (raimonster@gmail.com)
|#

(in-package :cl-user)
(defpackage clit-test-asd
  (:use :cl :asdf))
(in-package :clit-test-asd)

(defsystem clit-test
  :author "Raimon Grau"
  :license "LLGPL"
  :depends-on (:clit
               :prove)
  :components ((:module "t"
                :components
                ((:test-file "clit"))))
  :description "Test system for clit"

  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))
