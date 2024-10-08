run:
	cd docs && python -m http.server 8000

deploy:
	forge create --rpc-url https://arb1.arbitrum.io/rpc --private-key 0x0 src/Ckbx.sol:Ckbx --constructor-args 1048576 500000000000000 1000

deploy-ganache:
	forge create --rpc-url http://127.0.0.1:8545 --private-key 0x4f3edf983ac636a65a842ce7c78d9aa706d3b113bce9c46f30d7d21715b23b1d src/Ckbx.sol:Ckbx --constructor-args 1048576 500000000000000 10

abi:
	rm -f docs/abi.js
	echo -n "CKBX_ABI = " > docs/abi.js
	forge inspect src/Ckbx.sol:Ckbx abi >> docs/abi.js