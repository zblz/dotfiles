function secret
	python -c 'import binascii, os; print(binascii.hexlify(os.urandom(30)).decode())'
end
