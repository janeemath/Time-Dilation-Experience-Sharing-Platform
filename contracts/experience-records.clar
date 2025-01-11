;; Experience Records Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-parameters (err u101))

;; Data Variables
(define-data-var experience-counter uint u0)
(define-map experiences uint {
    user: principal,
    simulation-id: uint,
    personal-time: uint,
    earth-time: uint,
    description: (string-utf8 1000)
})

;; Public Functions
(define-public (record-experience (simulation-id uint) (personal-time uint) (earth-time uint) (description (string-utf8 1000)))
    (let
        (
            (experience-id (+ (var-get experience-counter) u1))
        )
        (asserts! (> personal-time u0) err-invalid-parameters)
        (asserts! (>= earth-time personal-time) err-invalid-parameters)
        (map-set experiences experience-id {
            user: tx-sender,
            simulation-id: simulation-id,
            personal-time: personal-time,
            earth-time: earth-time,
            description: description
        })
        (var-set experience-counter experience-id)
        (ok experience-id)
    )
)

(define-read-only (get-experience (experience-id uint))
    (map-get? experiences experience-id)
)

(define-read-only (get-experience-count)
    (var-get experience-counter)
)

