all:
	hugo -d /var/www/coredns.io

.PHONY: clean
clean:
	rm -rf /var/www/coredns.io/*

.PHONY: test
test:
	hugo server

# Sync CoreDNS' plugin README.md's to coredns.io. Uses $GOPATH to find them.
# Also sync the release notes from the notes directory.
.PHONY: sync
sync:
	( cd bin; ./sync-from-coredns.py $$GOPATH/src/github.com/coredns/coredns/plugin )
	cp $$GOPATH/src/github.com/coredns/coredns/notes/coredns-* content/blog

# Scan all markdown files for Corefile snippets and check validity
# github.com/miekg/corecheck
.PHONY: scan
scan:
	corecheck -exe $$GOPATH/src/github.com/coredns/coredns/coredns -dir content/blog
	corecheck -exe $$GOPATH/src/github.com/coredns/coredns/coredns -dir content/manual
