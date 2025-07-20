;; Accessibility Compliance Contract
;; Maintains ADA-compliant playground features and accessibility standards

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u400))
(define-constant ERR-FEATURE-NOT-FOUND (err u401))
(define-constant ERR-AUDIT-NOT-FOUND (err u402))
(define-constant ERR-INVALID-COMPLIANCE-LEVEL (err u403))

;; Data Variables
(define-data-var next-feature-id uint u1)
(define-data-var next-audit-id uint u1)

;; Data Maps
(define-map accessibility-features
  { feature-id: uint }
  {
    name: (string-ascii 100),
    feature-type: (string-ascii 50),
    location: (string-ascii 100),
    ada-compliant: bool,
    compliance-level: uint,
    installation-date: uint,
    last-audit: uint,
    maintenance-required: bool
  }
)

(define-map accessibility-audits
  { audit-id: uint }
  {
    feature-id: uint,
    auditor: principal,
    audit-date: uint,
    compliance-score: uint,
    findings: (string-ascii 500),
    recommendations: (string-ascii 500),
    follow-up-required: bool
  }
)

(define-map authorized-auditors
  { auditor: principal }
  { authorized: bool }
)

;; Authorization Functions
(define-public (authorize-auditor (auditor principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (ok (map-set authorized-auditors { auditor: auditor } { authorized: true }))
  )
)

;; Feature Management
(define-public (register-accessibility-feature
  (name (string-ascii 100))
  (feature-type (string-ascii 50))
  (location (string-ascii 100))
  (ada-compliant bool)
  (compliance-level uint))
  (let ((feature-id (var-get next-feature-id)))
    (begin
      (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
      (asserts! (and (>= compliance-level u1) (<= compliance-level u5)) ERR-INVALID-COMPLIANCE-LEVEL)

      (map-set accessibility-features
        { feature-id: feature-id }
        {
          name: name,
          feature-type: feature-type,
          location: location,
          ada-compliant: ada-compliant,
          compliance-level: compliance-level,
          installation-date: block-height,
          last-audit: u0,
          maintenance-required: false
        }
      )

      (var-set next-feature-id (+ feature-id u1))
      (ok feature-id)
    )
  )
)

;; Audit Functions
(define-public (conduct-accessibility-audit
  (feature-id uint)
  (compliance-score uint)
  (findings (string-ascii 500))
  (recommendations (string-ascii 500))
  (follow-up-required bool))
  (let ((audit-id (var-get next-audit-id)))
    (begin
      (asserts! (default-to false (get authorized (map-get? authorized-auditors { auditor: tx-sender }))) ERR-NOT-AUTHORIZED)
      (asserts! (is-some (map-get? accessibility-features { feature-id: feature-id })) ERR-FEATURE-NOT-FOUND)
      (asserts! (and (>= compliance-score u1) (<= compliance-score u100)) ERR-INVALID-COMPLIANCE-LEVEL)

      (map-set accessibility-audits
        { audit-id: audit-id }
        {
          feature-id: feature-id,
          auditor: tx-sender,
          audit-date: block-height,
          compliance-score: compliance-score,
          findings: findings,
          recommendations: recommendations,
          follow-up-required: follow-up-required
        }
      )

      ;; Update feature with audit information
      (map-set accessibility-features
        { feature-id: feature-id }
        (merge
          (unwrap! (map-get? accessibility-features { feature-id: feature-id }) ERR-FEATURE-NOT-FOUND)
          {
            last-audit: block-height,
            ada-compliant: (>= compliance-score u80),
            maintenance-required: follow-up-required
          }
        )
      )

      (var-set next-audit-id (+ audit-id u1))
      (ok audit-id)
    )
  )
)

(define-public (update-compliance-status (feature-id uint) (compliant bool) (maintenance-required bool))
  (let ((feature (unwrap! (map-get? accessibility-features { feature-id: feature-id }) ERR-FEATURE-NOT-FOUND)))
    (begin
      (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)

      (map-set accessibility-features
        { feature-id: feature-id }
        (merge feature {
          ada-compliant: compliant,
          maintenance-required: maintenance-required
        })
      )
      (ok true)
    )
  )
)

;; Read-only Functions
(define-read-only (get-accessibility-feature (feature-id uint))
  (map-get? accessibility-features { feature-id: feature-id })
)

(define-read-only (get-accessibility-audit (audit-id uint))
  (map-get? accessibility-audits { audit-id: audit-id })
)

(define-read-only (is-auditor-authorized (auditor principal))
  (default-to false (get authorized (map-get? authorized-auditors { auditor: auditor })))
)

(define-read-only (get-compliance-status (feature-id uint))
  (match (map-get? accessibility-features { feature-id: feature-id })
    feature (get ada-compliant feature)
    false
  )
)

(define-read-only (get-next-feature-id)
  (var-get next-feature-id)
)

(define-read-only (get-next-audit-id)
  (var-get next-audit-id)
)
