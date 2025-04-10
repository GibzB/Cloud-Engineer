for i in {1..5}; do
  curl -s http://135.119.174.94/info.php > /dev/null
  echo "Request $i completed"
  sleep 1 # Wait for 1 second between requests (optional)
done