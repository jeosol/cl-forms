(in-package :forms)

(defclass integer-form-field (form-field)
  ()
  (:documentation "An integer input field"))

(defmethod validate-form-field ((form-field integer-form-field))
  (multiple-value-bind (valid-p error)
   (funcall (clavier:is-an-integer "~A is not an integer" (field-name form-field))
	    (field-value form-field))
    (multiple-value-bind (valid-constraints-p errors)
	(call-next-method)
      (values (and valid-p valid-constraints-p)
	      (if error (cons error errors)
		  errors)))))

(defmethod field-read-from-request ((field integer-form-field) form parameters)
  (setf (field-value field)
	(let ((value 
	       (cdr (assoc (form-field-name field form) parameters :test #'string=))))
	  (and value
	       (parse-integer value :junk-allowed t)))))

(defmethod make-form-field ((field-type (eql :integer)) &rest args)
  (apply #'make-instance 'integer-form-field args))
