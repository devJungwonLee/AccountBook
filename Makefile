generate:
	tuist install
	tuist generate

clean:
	rm -rf Projects/**/*.xcodeproj
	rm -rf *.xcworkspace
	
reset:
	tuist clean
	@if [ -e ./Tuist/Package.resolved ] ; then \
		rm Tuist/Package.resolved; \
	fi
	make clean
