run:
	cd server && python -m http.server 8000

deploy:
	forge create --rpc-url 127.0.0.1:8545 --private-key 0x4f3edf983ac636a65a842ce7c78d9aa706d3b113bce9c46f30d7d21715b23b1d src/FlipFlop.sol:FlipFlop --constructor-args 1048576 1000