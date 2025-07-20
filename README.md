# Digital Public Playground Safety System

A comprehensive blockchain-based system for managing playground safety, maintenance, and community engagement using Clarity smart contracts.

## Overview

This system consists of five interconnected smart contracts that work together to ensure playground safety and community involvement:

1. **Equipment Inspection Contract** - Schedules and tracks safety inspections and maintenance
2. **Incident Reporting Contract** - Records and manages playground incidents and safety concerns
3. **Age-Appropriate Zoning Contract** - Ensures proper equipment placement for different age groups
4. **Accessibility Compliance Contract** - Maintains ADA-compliant playground features
5. **Community Input Contract** - Manages resident feedback and improvement suggestions

## Features

### Equipment Inspection System
- Schedule regular safety inspections
- Track maintenance repairs and completion status
- Assign certified inspectors to equipment
- Generate inspection reports with severity ratings

### Incident Reporting
- Record playground injuries and safety incidents
- Track incident severity and required actions
- Link incidents to specific equipment for pattern analysis
- Maintain incident resolution status

### Age-Appropriate Zoning
- Define age groups (2-5, 5-12, 13+ years)
- Assign equipment to appropriate age zones
- Validate equipment placement and safety requirements
- Ensure proper separation between age groups

### Accessibility Compliance
- Track ADA-compliant features and equipment
- Schedule accessibility audits
- Manage compliance status and required improvements
- Ensure inclusive playground design

### Community Input Management
- Collect and categorize resident feedback
- Track improvement suggestions and implementation
- Enable community voting on proposed changes
- Maintain transparency in decision-making

## Contract Architecture

Each contract is designed to be independent while allowing for future integration. The system uses:

- **Principal-based access control** for authorized personnel
- **Structured data types** for consistent information storage
- **Error handling** with descriptive error codes
- **Event logging** for transparency and auditing

## Getting Started

### Prerequisites
- Clarinet CLI installed
- Node.js and npm for testing
- Basic understanding of Clarity smart contracts

### Installation

1. Clone the repository
2. Install dependencies: \`npm install\`
3. Run tests: \`npm test\`
4. Deploy contracts: \`clarinet deploy\`

### Usage

Each contract provides specific functions for its domain:

- Equipment inspections can be scheduled and completed
- Incidents can be reported and tracked to resolution
- Age zones can be configured and validated
- Accessibility features can be audited and maintained
- Community feedback can be collected and processed

## Testing

The system includes comprehensive tests using Vitest:

\`\`\`bash
npm test
\`\`\`

Tests cover:
- Contract deployment and initialization
- Function execution and error handling
- Data integrity and validation
- Access control and permissions

## Contributing

This system is designed for public playground safety. Contributions should focus on:
- Enhanced safety features
- Improved accessibility compliance
- Better community engagement tools
- Comprehensive testing coverage

## License

Open source - designed for public benefit and community safety.
