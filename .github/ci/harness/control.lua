-- Verifies during the pull request checks that nothing can freeze: no planet
-- requires heating and no entity needs heating energy. With Space Age enabled
-- the check also requires Aquilo to exist, so it cannot pass vacuously.

script.on_init(function()
  if script.active_mods["space-age"] and not prototypes.space_location["aquilo"] then
    error("ci-harness: Space Age is enabled but Aquilo does not exist")
  end

  for name, location in pairs(prototypes.space_location) do
    if location.entities_require_heating then
      error("ci-harness: entities on " .. name .. " still require heating")
    end
  end

  for name, entity in pairs(prototypes.entity) do
    if entity.heating_energy > 0 then
      error("ci-harness: " .. name .. " still needs heating energy")
    end
  end

  log("ci-harness: ok, nothing can freeze")
end)
