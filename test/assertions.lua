function assert_keys(expected, hash)
  results = {}
  for key, value in pairs(hash) do
    table.insert(results, key)
  end
  assert_equal(table.sort(expected), table.sort(results))
end
