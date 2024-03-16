;; Define Blockcity Contract

;; Import necessary trait
(impl-trait 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.nft-trait.nft-trait)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))

;; Define NFT Token
(define-non-fungible-token blockcity uint)

;; Data Variable to Track Last Token ID
(define-data-var last-token-id uint u0)

;; Read-only function to get the last token ID
(define-read-only (get-last-token-id)
    (ok (var-get last-token-id))
)

;; Read-only function to get token URI
(define-read-only (get-token-uri (token-id uint))
    (ok none)
)

;; Read-only function to get token owner
(define-read-only (get-owner (token-id uint))
    (ok (nft-get-owner? blockcity token-id))
)

;; Public function to transfer token
(define-public (transfer (token-id uint) (sender principal) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender sender) err-not-token-owner)
        (nft-transfer? blockcity token-id sender recipient)
    )
)

;; Public function to mint new token
(define-public (mint (recipient principal))
    (let
        (
            (token-id (+ (var-get last-token-id) u1))
        )
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (try! (nft-mint? blockcity token-id recipient))
        (var-set last-token-id token-id)
        (ok token-id)
    )
)
