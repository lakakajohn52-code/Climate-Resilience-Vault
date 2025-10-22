# 🌍 Climate Resilience Vault

A comprehensive smart contract system for funding and managing climate adaptation projects on the Stacks blockchain. The Climate Resilience Vault enables communities to propose climate resilience projects, receive funding, track environmental impact, and earn rewards for successful outcomes.

## ✨ Features

### 🏗️ Core Functionality
- **Project Registration**: Submit climate adaptation projects with detailed proposals
- **Multi-stage Funding**: Initial funding with milestone-based disbursements  
- **Impact Tracking**: Monitor and verify environmental outcomes
- **Community Governance**: Stakeholder voting on project approval and funding
- **Reward System**: Incentivize successful project completion and impact achievement

### 🔐 Security Features
- Role-based access control with admin oversight
- Multi-signature requirements for large funding decisions
- Transparent audit trails for all transactions
- Emergency pause functionality for security incidents
- Time-locked funding releases based on milestones

## 🚀 Contract Functions

### Project Management
```clarity
;; Register a new climate project
(register-project project-id title description funding-goal timeline category)

;; Submit project milestones and evidence
(submit-milestone project-id milestone-id evidence-hash)

;; Update project status and impact metrics
(update-project-impact project-id carbon-reduction adaptation-score)
```

### Funding Operations  
```clarity
;; Contribute funds to a project
(contribute-to-project project-id amount)

;; Release milestone-based funding
(release-milestone-funding project-id milestone-id)

;; Distribute rewards based on impact
(distribute-impact-rewards project-id)
```

### Governance & Voting
```clarity
;; Vote on project proposals
(vote-on-project project-id vote approval-weight)

;; Approve projects for funding
(approve-project project-id)

;; Emergency governance actions
(emergency-pause)
```

## 💡 Usage Examples

### Registering a Climate Project
```clarity
;; Solar microgrid project for rural community
(contract-call? .climate-resilience-vault register-project
  u1001
  "Community Solar Microgrid"
  "Install 50kW solar system with battery storage for 200 households"
  u100000 ;; 100,000 STX funding goal
  u180    ;; 6-month timeline
  "renewable-energy")
```

### Contributing to a Project
```clarity
;; Community member contributes 1,000 STX
(contract-call? .climate-resilience-vault contribute-to-project u1001 u1000)
```

### Submitting Impact Evidence
```clarity
;; Project owner submits evidence of carbon reduction
(contract-call? .climate-resilience-vault update-project-impact
  u1001
  u50000  ;; 50 tons CO2 reduced annually
  u85)    ;; Adaptation score of 85/100
```

## 🎯 Project Categories

The vault supports various climate adaptation project types:

- 🌱 **Renewable Energy**: Solar, wind, and other clean energy systems
- 🌊 **Water Management**: Flood protection, rainwater harvesting, irrigation
- 🏡 **Resilient Infrastructure**: Climate-proof buildings and transportation
- 🌳 **Ecosystem Restoration**: Reforestation, wetland restoration, biodiversity
- 🌾 **Sustainable Agriculture**: Climate-smart farming and food security
- ⚡ **Energy Storage**: Battery systems and grid resilience
- 🚰 **Clean Technology**: Water purification, waste management, circular economy

## 💰 Economic Model

### Funding Mechanisms
- **Community Contributions**: Direct STX contributions from supporters
- **Institutional Grants**: Large-scale funding from climate organizations  
- **Carbon Credit Integration**: Revenue from verified emission reductions
- **Impact-Based Rewards**: Bonus funding for exceptional environmental outcomes

### Revenue Streams
- Platform transaction fees (2-5% of project funding)
- Carbon credit marketplace commissions
- Premium project management services
- Impact verification and certification fees

## 🛠️ Installation & Setup

### Prerequisites
- [Clarinet](https://github.com/hirosystems/clarinet) installed
- Stacks CLI tools
- Node.js 16+ for testing utilities

### Getting Started
```bash
# Clone the repository
git clone <repository-url>
cd climate-resilience-vault

# Initialize Clarinet project
clarinet new climate-vault
cd climate-vault

# Copy contract files
cp ../contracts/climate-resilience-vault.clar contracts/
cp ../Clarinet.toml .

# Validate contract
clarinet check

# Run tests
clarinet test
```

### Local Development
```bash
# Start local blockchain
clarinet integrate

# Deploy contract locally
clarinet deploy --local

# Interact with contract functions
clarinet console
```

## 🧪 Testing

The project includes comprehensive test coverage:

```bash
# Run all tests
npm test

# Test specific functionality
npm run test:projects     # Project registration and management
npm run test:funding      # Funding and disbursement flows  
npm run test:governance   # Voting and approval processes
npm run test:impact       # Impact tracking and rewards
npm run test:security     # Access control and safety features
```

## 📊 Error Codes

| Code | Constant | Description |
|------|----------|-------------|
| 100 | ERR-NOT-AUTHORIZED | Caller lacks required permissions |
| 101 | ERR-INVALID-PROJECT | Project ID not found or invalid |
| 102 | ERR-INSUFFICIENT-FUNDS | Not enough STX for the operation |
| 103 | ERR-PROJECT-NOT-ACTIVE | Project is not in active state |
| 104 | ERR-MILESTONE-NOT-REACHED | Milestone requirements not met |
| 105 | ERR-VOTING-PERIOD-ENDED | Governance voting window closed |
| 106 | ERR-ALREADY-VOTED | User has already cast vote |
| 107 | ERR-PAUSED | Contract is in emergency pause state |

## 📈 Platform Analytics

Track key performance indicators:

- **📊 Total Projects**: Number of registered climate initiatives
- **💵 Funds Deployed**: Total STX allocated to projects
- **🌿 Impact Metrics**: Aggregate carbon reduction and adaptation scores  
- **🏆 Success Rate**: Percentage of projects completing milestones
- **🌍 Global Reach**: Geographic distribution of funded projects
- **⚡ Energy Generated**: Renewable energy capacity added
- **👥 Community Engagement**: Number of contributors and voters

## 🤝 Contributing

We welcome contributions from the climate and blockchain communities!

### Development Process
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-climate-feature`
3. Make your changes with tests
4. Run the test suite: `npm test`
5. Submit a pull request with detailed description

### Code Standards
- Follow Clarity best practices and style guide
- Include comprehensive tests for new functionality
- Document all public functions with clear examples
- Ensure security review for fund-handling code

## 🚢 Deployment

### Testnet Deployment
```bash
# Deploy to Stacks testnet
clarinet deploy --testnet

# Verify contract deployment
stacks-cli contract-call <contract-address> get-contract-info
```

### Mainnet Deployment
```bash
# Production deployment (requires mainnet STX)
clarinet deploy --mainnet

# Set up monitoring and alerts
npm run setup-monitoring
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🌟 Acknowledgments

- **Stacks Foundation** for blockchain infrastructure
- **Climate tech community** for domain expertise
- **Open source contributors** for code and testing
- **Climate adaptation organizations** for real-world validation

---

**Built with 💚 for climate resilience and community empowerment**

*Together, we can build a more resilient and sustainable future through decentralized climate finance.*