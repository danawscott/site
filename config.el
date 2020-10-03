;; configure my personal portfolio site

;; Copyright © 2020 Dana Scott

;; This program is free software: you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see
;; <https://www.gnu.org/licenses/>.

;; "always publish all files"
(setq org-publish-use-timestamps-flag nil)

;; "The document author"
(setq user-full-name "Dana Scott")

;; how to test on dev machine
;; cd ~/backup/offprem/wiki/site
;; python3 -m http.server 8000 --bind 127.0.0.1
;; see https://docs.python.org/3/library/http.server.html

(defvar site-local
  "configure a site for a local machine if t or a server if nil")

(setq site-local nil)

(defconst localhost "http://localhost:8000")

(defconst domainhost "https://danawscott.com")

(defun site-preamble (_plist)
  (let ((host (if site-local localhost domainhost)))
    (concat "<nav>"
            "<ol>"
            (format "<li><a href=\"%s\">Home</a></li>" host)
            (format "<li><a href=\"%s/2/projects%s\">Projects</a></li>" host (if site-local ".html" ""))
            "</ol>"
            "</nav>")))

(defun local-or-domain (tag)
  (if site-local
      (concat localhost tag ".html")
    (concat domainhost tag)))

(setq org-link-abbrev-alist
      '(("site" . local-or-domain)))

(setq org-publish-project-alist
      `(("site"
         :base-directory ,(concat org-directory "site")
         :exclude "README.org"
         :publishing-directory ,(concat org-directory "site")
         :recursive t
         :publishing-function org-html-publish-to-html
         ;; "publish htmlized source"
         ;; :htmlized-source t
         :html-checkbox-type html
         :html-container "section"
         ;; "The cdrs of each entry are the ELEMENT_TYPE and ID for each
         ;; section of the exported document"
         :html-divs ((preamble "header" "preamble")
                     (content "main" "content")
                     (postamble "footer" "postamble"))
         ;; C-h v org-html-doctype-alist
         :html-doctype "html5"
         ;; exclude default style: org-html-style-default
         :html-head-include-default-style nil
         ;; exclude the value of org-html-scripts
         :html-head-include-scripts nil
         ;; "Use 'org-html-head' to use your own style information"
         :html-head "<link rel=\"stylesheet\" href=\"/style.css\">"
         ;; "More head information to add in the HTML output"
         :html-head-extra "<link href=\"https://fonts.googleapis.com/css2?family=Thasadith&display=swap\" rel=\"stylesheet\">"
         ;; use "new HTML5 elements"
         :html-html5-fancy t
         :html-postamble "<p>Copyright © 2020 Dana Scott</p>"
         :html-preamble site-preamble
         ;; C-h v org-html-text-markup-alist
         :html-text-markup-alist ((bold . "<strong>%s</strong>")
                                  (code . "<code>%s</code>")
                                  (italic . "<em>%s</em>")
                                  (strike-through . "<del>%s</del>")
                                  (underline . "<span class=\"underline\">%s</span>")
                                  (verbatim . "<span class=\"verbatim\">%s</span>"))
         ;; C-h v org-html-toplevel-hlevel
         :html-toplevel-hlevel 1
         ;; C-h v org-html-viewport
         ;; "The viewport meta tag is inserted if this variable is
         ;; non-nil"
         :html-viewport ((width "device-width") ; "Size of the viewport"
                         (initial-scale "1"))   ; "Zoom level when the page is first loaded"
         ;; C-h v org-export-with-title
         :with-title nil
         ;; don't "add section numbers to headlines when exporting"
         :section-numbers nil
         ;; "no table of contents is created"
         :with-toc nil
         )))
