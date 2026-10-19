-- Entities freeze only on planets that require heating (Aquilo in Space Age), and
-- only when they have heating energy. Both are turned off for every planet and
-- every entity, including those added by other mods; hence data-final-fixes.

for _, planet in pairs(data.raw["planet"] or {}) do
  planet.entities_require_heating = false
end

for _, prototypes in pairs(data.raw) do
  for _, prototype in pairs(prototypes) do
    if prototype.heating_energy then
      prototype.heating_energy = nil
    end
  end
end
