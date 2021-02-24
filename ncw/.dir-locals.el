;;; -*- lexical-binding: t; -*-
((
  org-mode .
  ((eval .
         (progn
           (require 'org-ql)

           (setq org-publish-project-alist
                 '(("ncw-html"
                    :base-directory "~/org/ncw/"
                    :base-extention "org"
                    :publishing-directory "~/org/ncw/public/"
                    :recursive t
                    :publishing-function org-html-publish-to-html
                    :html-container "section"
                    :html-head-extra "<link rel='stylesheet' href='aesthetic/main.css' />"
                    :html-divs ((preamble "div" "preamble")
                                (content "article" "content")
                                (postamble "div" "postamble"))
                    :html-doctype "html5"
                    :headline-levels 2
                    :html-html5-fancy t)))

           (org-link-set-parameters "dfn"
                                    ;; :follow #'org-dfn-follow
                                    :export #'org-dfn-export)

           (defcustom org-man-command 'dfn
             "Emacs link to pull from local glossary"
             :group 'org-link)

           (defun org-dfn-pull-term (term)
             "Pull definition of term, TERM, from local GLOSSARY.
GLOSSARY assumed to be org file where headings are TERMs and each
heading has a property drawer with a DEFINITION value"
             (cdr (car(-filter (lambda (x) (string= (car x) "DEFINITION"))
                               (car (org-ql-query
                                      :select '(org-entry-properties)
                                      :from "~/org/ncw/glossary.org"
                                      :where `(heading ,term)))))))
           (defun gloss-snippet (description definition)
             (let ((html "<span class='glossary-term'
                                onclick='this.classList.toggle(\"visible\")'>
                            %s
                           <span class='glossary-term_inner'>
                             %s
                           </span>
                          </span>"))
               (format html description definition)))

           (defun org-dfn-export (link description format _)
             "Export a man page link from Org files."
             (let ((desc (or description link))
                   (definition (org-dfn-pull-term link)))
               (pcase format
                 (`html (gloss-snippet desc definition))
     ;;                    (format "
     ;; <span class='glossary-term'
     ;;        onclick='this.classList.toggle(\"visible\")'>
     ;; %s
     ;;    <span class='glossary-term_inner'>%s</span>
     ;; </span>" desc definition))
                 (`latex (format "\\href{%s}{%s}" path desc))
                 (`texinfo (format "@uref{%s,%s}" path desc))
                 (`ascii (format "%s (%s)" desc path))
                 (t path)))))))))
