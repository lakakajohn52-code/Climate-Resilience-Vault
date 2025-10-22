;; Climate Resilience Vault Smart Contract
;; A comprehensive platform for funding climate adaptation projects on Stacks blockchain

;; Error constants
(define-constant ERR_UNAUTHORIZED u401)
(define-constant ERR_PROJECT_NOT_FOUND u402)
(define-constant ERR_INSUFFICIENT_FUNDS u403)
(define-constant ERR_INVALID_AMOUNT u404)
(define-constant ERR_PROJECT_COMPLETED u405)
(define-constant ERR_INVALID_STATUS u406)
(define-constant ERR_ALREADY_CONTRIBUTED u407)
(define-constant ERR_INVALID_IMPACT u408)
(define-constant ERR_VAULT_LOCKED u409)
(define-constant ERR_INVALID_PERIOD u410)
(define-constant ERR_MILESTONE_NOT_REACHED u411)
(define-constant ERR_VOTING_PERIOD_ENDED u412)
(define-constant ERR_ALREADY_VOTED u413)
(define-constant ERR_PAUSED u414)

;; Project status constants
(define-constant PROJECT_STATUS_ACTIVE u0)
(define-constant PROJECT_STATUS_FUNDED u1) 
(define-constant PROJECT_STATUS_IMPLEMENTING u2)
(define-constant PROJECT_STATUS_COMPLETED u3)
(define-constant PROJECT_STATUS_VERIFIED u4)
(define-constant PROJECT_STATUS_CANCELLED u5)

;; Climate project types
(define-constant CLIMATE_TYPE_RENEWABLE_ENERGY u0)
(define-constant CLIMATE_TYPE_CARBON_CAPTURE u1)
(define-constant CLIMATE_TYPE_REFORESTATION u2)
(define-constant CLIMATE_TYPE_FLOOD_PROTECTION u3)
(define-constant CLIMATE_TYPE_DROUGHT_RESISTANCE u4)
(define-constant CLIMATE_TYPE_CLEAN_TRANSPORT u5)
(define-constant CLIMATE_TYPE_ENERGY_STORAGE u6)
(define-constant CLIMATE_TYPE_WATER_MANAGEMENT u7)

;; Impact level constants
(define-constant IMPACT_LEVEL_LOW u0)
(define-constant IMPACT_LEVEL_MEDIUM u1)
(define-constant IMPACT_LEVEL_HIGH u2)
(define-constant IMPACT_LEVEL_CRITICAL u3)

;; Configuration constants
(define-constant MIN_PROJECT_FUNDING u1000000)
(define-constant MAX_PROJECT_FUNDING u50000000)
(define-constant VAULT_LOCK_PERIOD u52560)
(define-constant IMPACT_REWARD_MULTIPLIER u150)
(define-constant VOTING_PERIOD u1008)
(define-constant MIN_MILESTONE_FUNDING u100000)

;; Data variables
(define-data-var project-counter uint u0)
(define-data-var milestone-counter uint u0)
(define-data-var report-counter uint u0)
(define-data-var total-vault-balance uint u0)
(define-data-var total-co2-offset uint u0)
(define-data-var total-projects-funded uint u0)
(define-data-var vault-admin principal tx-sender)
(define-data-var is-paused bool false)
(define-data-var platform-fee-rate uint u25)

;; Climate projects map
(define-map climate-projects uint {
    project-id: uint,
    creator: principal,
    title: (string-ascii 100),
    description: (string-ascii 500),
    location: (string-ascii 100),
    climate-type: uint,
    funding-goal: uint,
    current-funding: uint,
    status: uint,
    creation-date: uint,
    completion-date: (optional uint),
    co2-reduction-target: uint,
    actual-co2-reduction: uint,
    impact-level: uint,
    verification-hash: (optional (string-ascii 64)),
    voting-end-date: uint,
    approval-votes: uint,
    rejection-votes: uint
})

;; Project contributions tracking
(define-map project-contributions { project-id: uint, contributor: principal } {
    amount-contributed: uint,
    contribution-date: uint,
    co2-credits-earned: uint,
    impact-rewards: uint,
    is-withdrawn: bool
})

;; Contributor profiles
(define-map contributor-profiles principal {
    total-contributed: uint,
    projects-supported: uint,
    co2-credits-total: uint,
    impact-rewards-total: uint,
    first-contribution-date: uint,
    green-reputation: uint,
    is-verified: bool
})

;; Climate impact validators
(define-map climate-validators principal {
    validator-id: uint,
    approved-by: principal,
    approval-date: uint,
    projects-validated: uint,
    accuracy-score: uint,
    is-active: bool,
    specialization: uint
})

;; Project milestones tracking
(define-map project-milestones { project-id: uint, milestone-id: uint } {
    title: (string-ascii 100),
    description: (string-ascii 300),
    target-date: uint,
    completion-date: (optional uint),
    co2-reduction: uint,
    funding-released: uint,
    is-verified: bool,
    verification-evidence: (optional (string-ascii 200))
})

;; Climate impact reports
(define-map climate-impact-reports uint {
    report-id: uint,
    project-id: uint,
    reporter: principal,
    report-date: uint,
    co2-reduced: uint,
    energy-generated: uint,
    area-protected: uint,
    verification-data: (string-ascii 500),
    validator-approval: (optional principal),
    is-verified: bool
})

;; Governance voting records
(define-map project-votes { project-id: uint, voter: principal } {
    vote: bool,
    voting-power: uint,
    vote-date: uint,
    stake-amount: uint
})

;; Vault staking deposits
(define-map vault-deposits { depositor: principal, deposit-date: uint } {
    amount: uint,
    lock-end-date: uint,
    climate-multiplier: uint,
    rewards-earned: uint,
    is-withdrawn: bool,
    auto-compound: bool
})

;; Create a comprehensive climate project
(define-public (create-climate-project 
    (title (string-ascii 100)) 
    (description (string-ascii 500)) 
    (location (string-ascii 100))
    (climate-type uint) 
    (funding-goal uint) 
    (co2-reduction-target uint)
    (impact-level uint))
    (let (
        (project-id (+ (var-get project-counter) u1))
        (voting-end (+ burn-block-height VOTING_PERIOD))
    )
        (asserts! (not (var-get is-paused)) (err ERR_PAUSED))
        (asserts! (>= funding-goal MIN_PROJECT_FUNDING) (err ERR_INVALID_AMOUNT))
        (asserts! (<= funding-goal MAX_PROJECT_FUNDING) (err ERR_INVALID_AMOUNT))
        (asserts! (<= climate-type CLIMATE_TYPE_WATER_MANAGEMENT) (err ERR_INVALID_STATUS))
        (asserts! (<= impact-level IMPACT_LEVEL_CRITICAL) (err ERR_INVALID_IMPACT))
        (asserts! (> co2-reduction-target u0) (err ERR_INVALID_AMOUNT))
        
        (map-set climate-projects project-id {
            project-id: project-id,
            creator: tx-sender,
            title: title,
            description: description,
            location: location,
            climate-type: climate-type,
            funding-goal: funding-goal,
            current-funding: u0,
            status: PROJECT_STATUS_ACTIVE,
            creation-date: burn-block-height,
            completion-date: none,
            co2-reduction-target: co2-reduction-target,
            actual-co2-reduction: u0,
            impact-level: impact-level,
            verification-hash: none,
            voting-end-date: voting-end,
            approval-votes: u0,
            rejection-votes: u0
        })
        
        (var-set project-counter project-id)
        (ok project-id)
    )
)

;; Contribute funds to a climate project with enhanced tracking
(define-public (contribute-to-project (project-id uint) (amount uint))
    (let (
        (project (unwrap! (map-get? climate-projects project-id) (err ERR_PROJECT_NOT_FOUND)))
        (existing-contribution (map-get? project-contributions { project-id: project-id, contributor: tx-sender }))
        (co2-credits (calculate-co2-credits amount (get climate-type project) (get impact-level project)))
        (impact-rewards (calculate-impact-rewards amount (get impact-level project)))
        (platform-fee (/ (* amount (var-get platform-fee-rate)) u1000))
        (net-contribution (- amount platform-fee))
    )
        (asserts! (not (var-get is-paused)) (err ERR_PAUSED))
        (asserts! (is-eq (get status project) PROJECT_STATUS_ACTIVE) (err ERR_INVALID_STATUS))
        (asserts! (> amount u0) (err ERR_INVALID_AMOUNT))
        (asserts! (is-none existing-contribution) (err ERR_ALREADY_CONTRIBUTED))
        
        ;; Transfer STX to contract
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        
        ;; Record contribution
        (map-set project-contributions { project-id: project-id, contributor: tx-sender } {
            amount-contributed: net-contribution,
            contribution-date: burn-block-height,
            co2-credits-earned: co2-credits,
            impact-rewards: impact-rewards,
            is-withdrawn: false
        })
        
        ;; Update project funding
        (map-set climate-projects project-id (merge project {
            current-funding: (+ (get current-funding project) net-contribution)
        }))
        
        ;; Update vault balance
        (var-set total-vault-balance (+ (var-get total-vault-balance) net-contribution))
        
        ;; Update contributor profile
        (update-contributor-profile tx-sender net-contribution co2-credits impact-rewards)
        
        ;; Check if project is fully funded
        (if (>= (+ (get current-funding project) net-contribution) (get funding-goal project))
            (begin
                (map-set climate-projects project-id (merge project {
                    current-funding: (+ (get current-funding project) net-contribution),
                    status: PROJECT_STATUS_FUNDED
                }))
                (var-set total-projects-funded (+ (var-get total-projects-funded) u1))
            )
            true
        )
        
        (ok { 
            net-contribution: net-contribution, 
            platform-fee: platform-fee,
            co2-credits: co2-credits, 
            impact-rewards: impact-rewards 
        })
    )
)

;; Start project implementation phase
(define-public (start-implementation (project-id uint))
    (let (
        (project (unwrap! (map-get? climate-projects project-id) (err ERR_PROJECT_NOT_FOUND)))
    )
        (asserts! (is-eq tx-sender (get creator project)) (err ERR_UNAUTHORIZED))
        (asserts! (is-eq (get status project) PROJECT_STATUS_FUNDED) (err ERR_INVALID_STATUS))
        
        (map-set climate-projects project-id (merge project {
            status: PROJECT_STATUS_IMPLEMENTING
        }))
        
        (ok true)
    )
)

;; Submit climate impact report
(define-public (report-climate-impact 
    (project-id uint) 
    (co2-reduced uint) 
    (energy-generated uint) 
    (area-protected uint) 
    (verification-data (string-ascii 500)))
    (let (
        (project (unwrap! (map-get? climate-projects project-id) (err ERR_PROJECT_NOT_FOUND)))
        (report-id (+ (var-get report-counter) u1))
    )
        (asserts! (is-eq tx-sender (get creator project)) (err ERR_UNAUTHORIZED))
        (asserts! (is-eq (get status project) PROJECT_STATUS_IMPLEMENTING) (err ERR_INVALID_STATUS))
        (asserts! (> co2-reduced u0) (err ERR_INVALID_AMOUNT))
        
        (map-set climate-impact-reports report-id {
            report-id: report-id,
            project-id: project-id,
            reporter: tx-sender,
            report-date: burn-block-height,
            co2-reduced: co2-reduced,
            energy-generated: energy-generated,
            area-protected: area-protected,
            verification-data: verification-data,
            validator-approval: none,
            is-verified: false
        })
        
        ;; Update project CO2 reduction
        (map-set climate-projects project-id (merge project {
            actual-co2-reduction: (+ (get actual-co2-reduction project) co2-reduced)
        }))
        
        (var-set report-counter report-id)
        (var-set total-co2-offset (+ (var-get total-co2-offset) co2-reduced))
        (ok report-id)
    )
)

;; Vote on project approval (governance mechanism)
(define-public (vote-on-project (project-id uint) (approve bool) (stake-amount uint))
    (let (
        (project (unwrap! (map-get? climate-projects project-id) (err ERR_PROJECT_NOT_FOUND)))
        (existing-vote (map-get? project-votes { project-id: project-id, voter: tx-sender }))
        (voting-power (calculate-voting-power tx-sender stake-amount))
    )
        (asserts! (is-none existing-vote) (err ERR_ALREADY_VOTED))
        (asserts! (<= burn-block-height (get voting-end-date project)) (err ERR_VOTING_PERIOD_ENDED))
        (asserts! (> stake-amount u0) (err ERR_INVALID_AMOUNT))
        
        ;; Lock voting stake
        (try! (stx-transfer? stake-amount tx-sender (as-contract tx-sender)))
        
        ;; Record vote
        (map-set project-votes { project-id: project-id, voter: tx-sender } {
            vote: approve,
            voting-power: voting-power,
            vote-date: burn-block-height,
            stake-amount: stake-amount
        })
        
        ;; Update project vote counts
        (if approve
            (map-set climate-projects project-id (merge project {
                approval-votes: (+ (get approval-votes project) voting-power)
            }))
            (map-set climate-projects project-id (merge project {
                rejection-votes: (+ (get rejection-votes project) voting-power)
            }))
        )
        
        (ok voting-power)
    )
)

;; Create project milestone
(define-public (create-milestone 
    (project-id uint) 
    (title (string-ascii 100)) 
    (description (string-ascii 300)) 
    (target-date uint) 
    (co2-reduction uint) 
    (funding-released uint))
    (let (
        (project (unwrap! (map-get? climate-projects project-id) (err ERR_PROJECT_NOT_FOUND)))
        (milestone-id (+ (var-get milestone-counter) u1))
    )
        (asserts! (is-eq tx-sender (get creator project)) (err ERR_UNAUTHORIZED))
        (asserts! (or (is-eq (get status project) PROJECT_STATUS_FUNDED) 
                     (is-eq (get status project) PROJECT_STATUS_IMPLEMENTING)) 
                 (err ERR_INVALID_STATUS))
        (asserts! (>= funding-released MIN_MILESTONE_FUNDING) (err ERR_INVALID_AMOUNT))
        
        (map-set project-milestones { project-id: project-id, milestone-id: milestone-id } {
            title: title,
            description: description,
            target-date: target-date,
            completion-date: none,
            co2-reduction: co2-reduction,
            funding-released: funding-released,
            is-verified: false,
            verification-evidence: none
        })
        
        (var-set milestone-counter milestone-id)
        (ok milestone-id)
    )
)

;; Complete project milestone
(define-public (complete-milestone (project-id uint) (milestone-id uint) (evidence (string-ascii 200)))
    (let (
        (project (unwrap! (map-get? climate-projects project-id) (err ERR_PROJECT_NOT_FOUND)))
        (milestone (unwrap! (map-get? project-milestones { project-id: project-id, milestone-id: milestone-id }) (err ERR_PROJECT_NOT_FOUND)))
    )
        (asserts! (is-eq tx-sender (get creator project)) (err ERR_UNAUTHORIZED))
        (asserts! (is-none (get completion-date milestone)) (err ERR_PROJECT_COMPLETED))
        
        (map-set project-milestones { project-id: project-id, milestone-id: milestone-id } (merge milestone {
            completion-date: (some burn-block-height),
            is-verified: true,
            verification-evidence: (some evidence)
        }))
        
        ;; Release milestone funding
        (try! (as-contract (stx-transfer? (get funding-released milestone) tx-sender (get creator project))))
        (ok true)
    )
)

;; Private helper functions
(define-private (calculate-co2-credits (amount uint) (climate-type uint) (impact-level uint))
    (let (
        (base-credits (/ amount u100000))
        (type-multiplier (+ climate-type u1))
        (impact-multiplier (+ impact-level u1))
    )
        (* (* base-credits type-multiplier) impact-multiplier)
    )
)

(define-private (calculate-impact-rewards (amount uint) (impact-level uint))
    (let (
        (base-reward (/ amount u1000000))
        (impact-multiplier (+ impact-level u1))
    )
        (* (* base-reward impact-multiplier) IMPACT_REWARD_MULTIPLIER)
    )
)

(define-private (calculate-voting-power (voter principal) (stake-amount uint))
    (let (
        (profile (default-to { total-contributed: u0, projects-supported: u0, co2-credits-total: u0, impact-rewards-total: u0, first-contribution-date: burn-block-height, green-reputation: u0, is-verified: false }
                            (map-get? contributor-profiles voter)))
        (reputation-bonus (/ (get green-reputation profile) u10))
        (base-power (/ stake-amount u1000))
    )
        (+ base-power reputation-bonus)
    )
)

(define-private (update-contributor-profile (contributor principal) (amount uint) (co2-credits uint) (impact-rewards uint))
    (let (
        (existing-profile (default-to { total-contributed: u0, projects-supported: u0, co2-credits-total: u0, impact-rewards-total: u0, first-contribution-date: burn-block-height, green-reputation: u0, is-verified: false }
                          (map-get? contributor-profiles contributor)))
    )
        (map-set contributor-profiles contributor {
            total-contributed: (+ (get total-contributed existing-profile) amount),
            projects-supported: (+ (get projects-supported existing-profile) u1),
            co2-credits-total: (+ (get co2-credits-total existing-profile) co2-credits),
            impact-rewards-total: (+ (get impact-rewards-total existing-profile) impact-rewards),
            first-contribution-date: (get first-contribution-date existing-profile),
            green-reputation: (+ (get green-reputation existing-profile) u10),
            is-verified: (get is-verified existing-profile)
        })
        true
    )
)

;; Read-only functions
(define-read-only (get-project (project-id uint))
    (map-get? climate-projects project-id)
)

(define-read-only (get-contribution (project-id uint) (contributor principal))
    (map-get? project-contributions { project-id: project-id, contributor: contributor })
)

(define-read-only (get-contributor-profile (contributor principal))
    (map-get? contributor-profiles contributor)
)

(define-read-only (get-milestone (project-id uint) (milestone-id uint))
    (map-get? project-milestones { project-id: project-id, milestone-id: milestone-id })
)

(define-read-only (get-impact-report (report-id uint))
    (map-get? climate-impact-reports report-id)
)

(define-read-only (get-project-stats (project-id uint))
    (match (map-get? climate-projects project-id)
        project (some {
            funding-progress: (if (> (get funding-goal project) u0)
                                (/ (* (get current-funding project) u100) (get funding-goal project))
                                u0),
            co2-progress: (if (> (get co2-reduction-target project) u0)
                            (/ (* (get actual-co2-reduction project) u100) (get co2-reduction-target project))
                            u0),
            days-since-creation: (/ (- burn-block-height (get creation-date project)) u144),
            is-fully-funded: (>= (get current-funding project) (get funding-goal project)),
            climate-impact-ratio: (if (> (get current-funding project) u0)
                                    (/ (get actual-co2-reduction project) (get current-funding project))
                                    u0)
        })
        none
    )
)

(define-read-only (get-vault-stats)
    {
        total-projects: (var-get project-counter),
        total-milestones: (var-get milestone-counter),
        total-reports: (var-get report-counter),
        total-vault-balance: (var-get total-vault-balance),
        total-co2-offset: (var-get total-co2-offset),
        total-projects-funded: (var-get total-projects-funded),
        vault-admin: (var-get vault-admin),
        is-paused: (var-get is-paused),
        platform-fee-rate: (var-get platform-fee-rate)
    }
)