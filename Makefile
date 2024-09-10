run:
	cd docs && python -m http.server 8000

deploy:
	forge create --rpc-url https://arb1.arbitrum.io/rpc --private-key 0x0 src/Ckbx.sol:Ckbx --constructor-args 1048576 500000000000000

abi:
	rm -f docs/abi.js
	echo -n "CKBX_ABI = " > docs/abi.js
	forge inspect src/Ckbx.sol:Ckbx abi >> docs/abi.js