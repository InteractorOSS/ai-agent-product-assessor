# Release Ready Checklist

Complete this checklist before releasing to production.

---

## Code Quality

### Verification
- [ ] All code reviewed and approved
- [ ] No open critical/high bugs
- [ ] No known regressions
- [ ] All acceptance criteria met

### Testing
- [ ] All unit tests passing
- [ ] All integration tests passing
- [ ] All E2E tests passing
- [ ] Coverage meets threshold (≥80%)
- [ ] Performance tests passed

### Security
- [ ] Security audit completed
- [ ] No critical vulnerabilities
- [ ] Dependency audit passed (`npm audit`)
- [ ] No secrets in codebase

---

## Documentation

### User-Facing
- [ ] Release notes drafted
- [ ] User documentation updated
- [ ] API documentation current
- [ ] Help content updated (if applicable)

### Technical
- [ ] README updated
- [ ] CHANGELOG updated
- [ ] Deployment documentation current
- [ ] Runbooks updated

### Internal
- [ ] Architecture documentation current
- [ ] Configuration documented
- [ ] Known issues documented

---

## Configuration

### Environment
- [ ] Environment variables documented
- [ ] Production values configured
- [ ] Secrets rotated (if needed)
- [ ] Feature flags set correctly

### Database
- [ ] Migrations tested on staging
- [ ] Rollback scripts prepared
- [ ] Indexes verified
- [ ] Data backup verified

### Infrastructure
- [ ] Resource limits configured
- [ ] Auto-scaling configured
- [ ] Load balancer health checks work
- [ ] SSL certificates valid

---

## Deployment

### Preparation
- [ ] Deployment scripts tested
- [ ] Rollback procedure documented
- [ ] Deployment window scheduled
- [ ] Team notified of deployment

### Staging
- [ ] Deployed to staging successfully
- [ ] Staging smoke tests passed
- [ ] Staging performance acceptable
- [ ] UAT sign-off obtained

### Production
- [ ] Production checklist reviewed
- [ ] On-call team notified
- [ ] Status page prepared
- [ ] Support team briefed

---

## Monitoring

### Dashboards
- [ ] Monitoring dashboards ready
- [ ] Key metrics tracked
- [ ] Error tracking configured

### Alerting
- [ ] Alerts configured
- [ ] Escalation path defined
- [ ] On-call schedule confirmed

### Logging
- [ ] Logging adequate
- [ ] Log aggregation working
- [ ] No sensitive data in logs

---

## Communication

### Internal
- [ ] Engineering team notified
- [ ] Product team notified
- [ ] Support team briefed
- [ ] Leadership informed

### External
- [ ] Customer communication prepared (if needed)
- [ ] Status page update prepared
- [ ] Marketing/PR coordinated (if applicable)

---

## Risk Assessment

### Identified Risks
| Risk | Impact | Mitigation |
|------|--------|------------|
| [Risk 1] | [H/M/L] | [Mitigation] |
| [Risk 2] | [H/M/L] | [Mitigation] |

### Rollback Triggers
- [ ] Error rate > [X]%
- [ ] Response time > [X]ms
- [ ] Critical bug discovered
- [ ] Security issue identified

### Rollback Plan
- [ ] Rollback procedure documented
- [ ] Rollback tested on staging
- [ ] Team knows rollback process
- [ ] Rollback can complete in < [X] minutes

---

## Post-Release Plan

### Immediate (0-1 hour)
- [ ] Monitor error rates
- [ ] Check performance metrics
- [ ] Verify critical user flows
- [ ] Watch for user reports

### Short-term (1-24 hours)
- [ ] Continue monitoring
- [ ] Address any issues
- [ ] Update status page
- [ ] Gather initial feedback

### Follow-up (1-7 days)
- [ ] Review release metrics
- [ ] Conduct post-mortem (if issues)
- [ ] Document lessons learned
- [ ] Plan any follow-up work

---

## Sign-offs

### Required Approvals

| Role | Name | Date | Status |
|------|------|------|--------|
| Engineering Lead | | | ☐ Pending |
| QA Lead | | | ☐ Pending |
| Product Owner | | | ☐ Pending |
| Security (if applicable) | | | ☐ Pending |

### Release Decision

- [ ] **GO** - All criteria met, proceed with release
- [ ] **NO-GO** - Issues need resolution before release

**Decision By**: _________________ **Date**: _________________

---

## Release Summary

| Item | Value |
|------|-------|
| **Version** | |
| **Release Date** | |
| **Release Manager** | |
| **Deployment Window** | |
| **Rollback Deadline** | |

---

## Quick Reference

### Smoke Test URLs
- Production: [URL]
- Health Check: [URL]/health
- API: [URL]/api/v1

### Key Contacts
| Role | Name | Phone |
|------|------|-------|
| On-call Engineer | | |
| Release Manager | | |
| Escalation | | |

### Important Links
- Deployment Pipeline: [Link]
- Monitoring Dashboard: [Link]
- Error Tracking: [Link]
- Status Page: [Link]
