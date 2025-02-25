;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname V3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
(define steuersatz-pro-1000-euro 0.5)

;; Type: number -> number
;; Returns taxrate for given income
(define (get-taxrate einkommen)
  (if (> einkommen 200000)
      100
      (* (floor (/ einkommen 1000)) steuersatz-pro-1000-euro)))

(check-expect (get-taxrate 300000) 100)
(check-expect (get-taxrate 40800) 20)
(check-expect (get-taxrate 0) 0)

;; Type: number -> number
;; Returns income after taxes
(define (get-income einkommen)
  (- einkommen (* einkommen (* 0.01 (get-taxrate einkommen)))))

(check-expect (get-income 40000) 32000)
(check-expect (get-income 500000) 0)
(check-expect (get-income 23700) 20974.5)
(check-expect (get-income 0) 0)