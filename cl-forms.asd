;;;; cl-forms.asd

(asdf:defsystem #:cl-forms
  :serial t
  :description "Describe cl-forms here"
  :author "Mariano Montone"
  :license "MIT"
  :depends-on (#:alexandria
               #:cl-ppcre
               #:hunchentoot
	       #:ironclad
	       #:uuid
	       #:clavier)
  :components ((:module :src
			:components
			((:file "package")
			 (:module :themes
				  :components
				  ((:file "theme")
				   (:file "default")
				   (:file "bootstrap")
				   (:file "specials"))
				  :serial t)
			 (:file "cl-forms")
			 (:module :fields
				  :components
				  ((:file "string")
				   (:file "boolean")
				   (:file "email")
				   (:file "password")
				   (:file "url")
				   (:file "integer")
				   (:file "choice")
				   (:file "submit"))))
			:serial t))
  :in-order-to ((asdf:test-op (asdf:test-op :cl-forms.test))))
	       
