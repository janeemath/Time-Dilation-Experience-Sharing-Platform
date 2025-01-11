;; Relativistic Event Synchronization Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-parameters (err u101))

;; Data Variables
(define-data-var event-counter uint u0)
(define-map relativistic-events uint {
    name: (string-ascii 100),
    description: (string-utf8 500),
    simulation-id: uint,
    local-time: uint,
    earth-time: uint
})

;; Public Functions
(define-public (create-event (name (string-ascii 100)) (description (string-utf8 500)) (simulation-id uint) (local-time uint) (earth-time uint))
    (let
        (
            (event-id (+ (var-get event-counter) u1))
        )
        (asserts! (is-some (contract-call? .time-dilation-simulations get-simulation simulation-id)) err-invalid-parameters)
        (asserts! (> local-time u0) err-invalid-parameters)
        (asserts! (> earth-time u0) err-invalid-parameters)
        (map-set relativistic-events event-id {
            name: name,
            description: description,
            simulation-id: simulation-id,
            local-time: local-time,
            earth-time: earth-time
        })
        (var-set event-counter event-id)
        (ok event-id)
    )
)

(define-read-only (get-event (event-id uint))
    (map-get? relativistic-events event-id)
)

(define-read-only (get-event-count)
    (var-get event-counter)
)

