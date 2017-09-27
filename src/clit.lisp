(in-package :cl-user)

(defpackage clit
  (:use :cl)
  ;; (:use :ironclad :arnesi :salza2)
  )

(in-package :clit)

(defvar *dir* "/tmp/clit/")


(defun ensure-list (l)
  (if (listp l)
      l
      (list l)))

;;; blob tree commit tag
(defun write-binary-file (path content)
  (with-open-file (s path
                     :direction :output
                     :if-exists :supersede
                     :if-does-not-exist :create
                     :element-type '(unsigned-byte 8))
    (dolist (c (ensure-list content))
      (write-sequence c s))))

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


(defvar +NULL+ #\Nul)


(defun digest-hex (arg)
  (format nil "~{~2,'0x~}" (coerce arg 'list)))

(defun sha1-str (string)
  (let ((digester (ironclad:make-digest :sha1)))
    (digest-hex
     (ironclad:produce-digest
      (ironclad:update-digest
       digester
       (arnesi:string-to-octets string :utf8))))))

(defun str-join (&rest strs)
  (apply 'concatenate 'string strs))

(defun hash-object (data obj-type &optional (write t))
  ;; (arnesi:string-to-octets "hjoal" :utf-8)
  (let* ((header (format nil
                         "~a ~a"
                         obj-type
                         (length data)))
         (full-data (format nil "~a~a~a" header +NULL+ data))
         (sha1 (sha1-str full-data)))
    (when write
      (let ((path (str-join ".git/objects/"
                            (subseq sha1 0 2)))
            (compressed-data (salza2:compress-data (sb-ext:string-to-octets
                                                    full-data)
                                                   'salza2:zlib-compressor)))
        (ensure-directories-exist path)
        (write-binary-file
         ;; (full-path ".git/objects/foo")
         (str-join path (subseq sha1 2))
         compressed-data
         )))
    sha1))


;; (defmacro set-once (place val)
;;   `(progn
;;      (declare (special ,place))
;;      (defvar ,place nil)
;;      (unless ,place (setf ,place ,val))))

(defun foo ()
  (set-once *l2* 3))
