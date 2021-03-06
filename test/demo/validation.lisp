(in-package :forms.test)

(forms:defform validated-form (:action "/validation-post"
				       :client-validation nil)
  ((name :string :value "" :constraints (list (clavier:is-a-string)
					      (clavier:not-blank)
					      (clavier:len :max 5)))
   (single :boolean :value t)
   (sex :choice :choices (list "Male" "Female") :value "Male")
   (age :integer :constraints (list (clavier:is-an-integer)
				    (clavier:greater-than -1)
				    (clavier:less-than 200)))
   (email :email)
   (submit :submit :label "Create")))

(defun validation-demo ()
  (let ((form (forms::get-form 'validated-form)))
    (forms:with-form-renderer :who
      (forms:render-form form))))

(hunchentoot:define-easy-handler (validated-form-post :uri "/validation-post" 
						      :default-request-type :post) ()

  (flet ((validation-post ()
	   (let ((form (forms:get-form 'validated-form)))
	     (forms::handle-request form)
	     (if (forms::validate-form form)
		 ;; The form is valid
		 (forms::with-form-field-values (name single sex age email) form
		   (who:with-html-output (forms.who::*html*)
		     (:ul 
		       (:li (who:fmt "Name: ~A" name))
		       (:li (who:fmt "Single: ~A" single))
		       (:li (who:fmt "Sex: ~A" sex))
		       (:li (who:fmt "Age: ~A" age))
		       (:li (who:fmt "Email: ~A" email)))))
		 ;; The form is not valid
		 (forms:with-form-renderer :who
		   (forms:render-form form))))))
    (render-demo-page :demo #'validation-post
		      :source (asdf:system-relative-pathname :cl-forms.demo 
							     "test/demo/validation.lisp")
		      :active-menu :validation)))

(hunchentoot:define-easy-handler (validation-demo-handler :uri "/validation") ()
  (render-demo-page :demo #'validation-demo
		    :source (asdf:system-relative-pathname :cl-forms.demo 
							   "test/demo/validation.lisp")
		    :active-menu :validation))
