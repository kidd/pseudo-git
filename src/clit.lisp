(in-package :cl-user)

(defpackage clit
  (:use :cl)
  ;; (:use :ironclad :arnesi)
  )

(in-package :clit)

(defvar *dir* "/tmp/clit/")

(defun write-binary-file (path content)
  (with-open-file (s path
                     :direction :output
                     :if-exists :supersede
                     :if-does-not-exist :create
                     :element-type '(unsigned-byte 8))
    (write-sequence content s)))


(defun write-file (path content)
  (with-open-file (s path
                     :direction :output
                     :if-exists :supersede)
    (format s "~a" content)))

(defun full-path (path)
  (merge-pathnames path  *dir*))

(defun join-list (list &optional (sep ""))
  (with-output-to-string (s)
    (loop for x in list
          for i from 0
          when (plusp i)
            do (princ sep s)
          do (princ x s))))

(defun init ()
  (let ((git-dirs '(".git/" ".git/objects/" ".git/refs/heads/")))
    (dolist (d git-dirs)
      (ensure-directories-exist
       (full-path d)))
    (write-file (full-path ".git/HEAD")
                "ref: refs/heads/master")))

(defun binary-data (&rest args)
  )


(defvar +NULL+ #x00)


(defun digest-hex (arg)
  (format nil "~{~2,'0x~}" (coerce arg 'list)))

(defun sha1-str (string)
  (let ((digester (ironclad:make-digest :sha1)))
    (;digest-hex
     progn
      (ironclad:produce-digest
      (ironclad:update-digest
       digester
       (arnesi:string-to-octets string :utf8))))))

(defun hash-object (data obj-type &optional (write t))
  (let* ((header (format nil "~a" obj-type (length data)))
         (full-data (join-list (list header +NULL+ data)))
         (sha1 (sha1 full-data)))
    (write-file (full-path ".git/foo") full-data)))


;; (defmacro set-once (place val)
;;   `(progn
;;      (declare (special ,place))
;;      (defvar ,place nil)
;;      (unless ,place (setf ,place ,val))))

(defun foo ()
  (set-once *l2* 3))
