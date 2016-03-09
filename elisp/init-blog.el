;; Prerequisites

;;   Need the extra =contrib= package:


(use-package org-plus-contrib
  :ensure t)



;; And then require them:


(require 'ox-html)
(require 'ox-publish)
(require 'ox-rss)



;; Need htmlize for the code highlighting in the exports:


(use-package htmlize
   :ensure t)

;; Blog Publishing Settings

;;    The brilliance of =org-mode= is the ability to publish your notes
;;    as HTML files into a web server. See [[http://orgmode.org/worg/org-tutorials/org-publish-html-tutorial.html][these instructions]]. I've
;;    transitioned over to the new =ox= exporter, see [[http://orgmode.org/worg/org-8.0.html][these instructions]].


(setq org-mode-websrc-directory (concat (getenv "HOME") "/website"))
(setq org-mode-publishing-directory (concat (getenv "HOME") "/Public/"))

(setq org-publish-project-alist
      `(("all"
         :components ("blog-content" "blog-static" "org-notes" "blog-rss"))

        ("blog-content"
         :base-directory       ,org-mode-websrc-directory
         :base-extension       "org"
         :publishing-directory ,org-mode-publishing-directory
         :recursive            t
         :publishing-function  org-html-publish-to-html
         :preparation-function org-mode-blog-prepare
         :export-with-tags     nil
         :headline-levels      4
         :auto-preamble        t
         :auto-postamble       nil
         :auto-sitemap         t
         :sitemap-title        "Howardisms"
         :section-numbers      nil
         :table-of-contents    nil
         :with-toc             nil
         :with-author          nil
         :with-creator         nil
         :with-tags            nil
         :with-smart-quotes    t

         :html-doctype         "html5"
         :html-html5-fancy     t
         :html-preamble        org-mode-blog-preamble
         :html-postamble       org-mode-blog-postamble
         ;; :html-postamble "<hr><div id='comments'></div>"
         :html-head  "<link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:400,700&subset=latin,latin-ext' rel='stylesheet' type='text/css'>
            <link href='http://fonts.googleapis.com/css?family=Source+Serif+Pro:400,700&subset=latin,latin-ext' rel='stylesheet' type='text/css'>
            <link href='http://fonts.googleapis.com/css?family=Source+Code+Pro:400,700' rel='stylesheet' type='text/css'>
            <link rel=\"stylesheet\" href=\"/css/styles.css\" type=\"text/css\"/>\n"
         :html-head-extra "<script src=\"https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js\"></script>
            <script src=\"/js/magic.js\"></script>
            <link rel=\"icon\" href=\"/img/dragon.svg\">
            <link rel=\"shortcut icon\" href=\"/img/dragon-head.png\">
            <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />"
         :html-head-include-default-style nil
         )

        ("blog-static"
         :base-directory       ,org-mode-websrc-directory
         :base-extension       "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|svg"
         :publishing-directory ,org-mode-publishing-directory
         :recursive            t
         :publishing-function  org-publish-attachment
         )

        ("blog-rss"
         :base-directory        ,org-mode-websrc-directory
         :base-extension        "org"
         :rss-image-url         "http://howardism.org/img/dragon-head.png"
         :publishing-directory  ,org-mode-publishing-directory
         :publishing-function   (org-rss-publish-to-rss)
         :html-link-home        "http://www.howardism.org/"
         :html-link-use-abs-url t
         :with-toc              nil
         :exclude               ".*"
         :include               ("index.org"))

        ("org-notes"
         :base-directory        "~/technical/"
          :base-extension       "org"
          :publishing-directory ,(concat org-mode-publishing-directory "/notes/")
          :recursive            t
          :publishing-function  org-html-publish-to-html
          :headline-levels      4             ; Just the default for this project.
          :auto-preamble        t
          :auto-sitemap         t             ; Generate sitemap.org automagically...
          :makeindex            t
          :section-numbers      nil
          :table-of-contents    nil
          :with-author          nil
          :with-creator         nil
          :with-tags            nil
          :style                "<link rel=\"stylesheet\" href=\"../css/styles.css\" type=\"text/css\"/> <script src=\"https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js\" type=\"text/javascript\"></script> <link href=\"http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/themes/smoothness/jquery-ui.css\" type=\"text/css\" rel=\"stylesheet\" />    <script src=\"https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js\" type=\"text/javascript\"></script> <script =\"text/javascript\" src=\"js/magic.js\"></script>"
        )

        ("org-notes-static"
         :base-directory       "~/technical/"
         :base-extension       "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory ,(concat org-mode-publishing-directory "/other/")
         :recursive            t
         :publishing-function  org-publish-attachment
         )))

(defun org-mode-blog-preamble (options)
  "The function that creates the preamble top section for the blog.
OPTIONS contains the property list from the org-mode export."
  (let ((base-directory (plist-get options :base-directory)))
    (org-babel-with-temp-filebuffer (expand-file-name "top-bar.html" base-directory) (buffer-string))))

(defun org-mode-blog-postamble (options)
  "The function that creates the postamble, or bottom section for the blog.
OPTIONS contains the property list from the org-mode export."
  (let ((base-directory (plist-get options :base-directory)))
    (org-babel-with-temp-filebuffer (expand-file-name "bottom.html" base-directory) (buffer-string))))

(defun org-mode-blog-prepare ()
  "`index.org' should always be exported so touch the file before publishing."
  (let* ((base-directory (plist-get project-plist :base-directory))
         (buffer (find-file-noselect (expand-file-name "index.org" base-directory) t)))
    (with-current-buffer buffer
      (set-buffer-modified-p t)
      (save-buffer 0))
    (kill-buffer buffer)))

;; Technical Artifacts

;;   Offer up the Elisp goodness to others:


(provide 'init-blog)
