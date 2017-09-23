--====================================================================
--====================================================================
-- MarI/O by SethBling
-- Modified by Sean Strange - Works for following NES Games
--		>Super Mario Bros.
--		>Super Mario Bros. 3
--		>PacMan
--		>MegaMan (Iceman and Fireman Levels)
--		>Captain SkyHawk

--Seth Bling Original Disclaimer:
-- 		Feel free to use this code, but please do not redistribute it.
-- 		Intended for use with the BizHawk emulator and Super Mario World or Super Mario Bros. ROM.
-- 		For SMW, make sure you have a save state named "DP1.state" at the beginning of a level,
-- 		and put a copy in both the Lua folder and the root directory of BizHawk.

--Version: June 2017
--====================================================================
--====================================================================

movie.stop()

--====================================================================
--If Not Captain SkyHawk, Graphics for Test Case Controls
if (not (gameinfo.getromname() == "Captain SkyHawk")) then
	infoBox = forms.newform(300, 500, "Instructions")
	forms.setlocation(infoBox, 400, 0)
	desc = forms.label(infoBox, "1.Choose one case", 5, 15)
	desc2 = forms.label(infoBox, "2. Select Start", 5, 40)
	desc3 = forms.label(infoBox, "Test Cases: Fitness", 90, 65)
	
	--Mario Test Cases
	mar = forms.label(infoBox, "Mario (1-4)", 5, 90)
	mar1 = forms.label(infoBox, "Mario 1: Rightmost", 25, 115)
	mar11 = forms.label(infoBox, "20 timeout", 125, 115)
	mar2 = forms.label(infoBox, "Mario 2: Rightmost", 25, 140)
	mar22 = forms.label(infoBox, "80 timeout", 125, 140)
	mar3 = forms.label(infoBox, "Mario 3: Score", 25, 165)
	mar33 = forms.label(infoBox, "250 timeout", 125, 165)
	mar4 = forms.label(infoBox, "Mario 4: Both^", 25, 190)
	mar44 = forms.label(infoBox, "80 timeout", 125, 190)

	--PacMan Test Cases
	pac = forms.label(infoBox, "Pacman (1-3)", 5, 215)
	pac1 = forms.label(infoBox, "Pac1: Pellets", 25, 240)
	pac11 = forms.label(infoBox, "250 timeout", 125, 240)
	pac2 = forms.label(infoBox, "Pac2: Score", 25, 265)
	pac22 = forms.label(infoBox, "250 timeout", 125, 265)
	pac3 = forms.label(infoBox, "Pac3: Both^", 25, 290)
	pac33 = forms.label(infoBox, "250 timeout", 125, 290)


	--Mega Man Test Cases
	meg = forms.label(infoBox, "MegaMan (1-2)", 5, 315)
	meg1 = forms.label(infoBox, "Meg1: Score", 25, 340)
	meg11 = forms.label(infoBox, "80 timeout", 125, 340)
	meg2 = forms.label(infoBox, "Meg2: Right+Score", 25, 365)
	meg2 = forms.label(infoBox, "80 timeout", 125, 365)

	--Case Control and Start Button
	caseControl = forms.newform(200, 300, "Case Control")
	startButton = forms.checkbox (caseControl, "Start", 75, 20)
	caseNum1 = forms.checkbox (caseControl, "Case 1", 5, 50)
	caseNum2 = forms.checkbox (caseControl, "Case 2", 5, 80)
	caseNum3 = forms.checkbox (caseControl, "Case 3", 5, 110)
	caseNum4 = forms.checkbox (caseControl, "Case 4", 5, 140)

	--Wait for Test Case to be Selected
	while (not (forms.ischecked(caseNum1) or forms.ischecked(caseNum2) or forms.ischecked(caseNum3) or forms.ischecked(caseNum4))) do
		emu.frameadvance()
	end

	if (forms.ischecked(caseNum1)) then
		caseNum = 1
	elseif (forms.ischecked(caseNum2)) then
		caseNum = 2
	elseif (forms.ischecked(caseNum3)) then
		caseNum = 3
	elseif (forms.ischecked(caseNum4)) then
		caseNum = 4
	else
		console.writeline("No case number selected. Will Crash")
	end	

	forms.destroy(caseControl)
	forms.destroy(infoBox)
end
--End Test Case Control
--====================================================================

--====================================================================
--Initial Configurations for Each Game. Save State, Buttons
if gameinfo.getromname() == "Super Mario Bros." then
	Filename = "SMB1-1.State"
	writePath = ".\\Super_Mario_Bros\\Case_" .. caseNum .. "\\"
	--Timeout Determination based on Test Case
	if (caseNum == 1) then
		TimeoutConstant = 20
	elseif (caseNum == 2) then
		TimeoutConstant = 80
	elseif (caseNum == 3) then
		TimeoutConstant = 250
	elseif (caseNum == 4) then
		TimeoutConstant = 80
	end

elseif gameinfo.getromname() == "Super Mario Bros. 3" then
	Filename = "SMB3_1-1.State"
	writePath = ".\\Super_Mario_Bros3\\Case_" .. caseNum .. "\\"
	--Timeout Determination based on Test Case
	if (caseNum == 1) then
		TimeoutConstant = 20
	elseif (caseNum == 2) then
		TimeoutConstant = 80
	elseif (caseNum == 3) then
		TimeoutConstant = 250
	elseif (caseNum == 4) then
		TimeoutConstant = 80
	end

elseif gameinfo.getromname() == "Pac-Man" then
	Filename = "Pac-Man.state"
	writePath = ".\\Pacman\\Case_" .. caseNum .. "\\"
	TimeoutConstant = 250

elseif (gameinfo.getromname() == "Mega Man") then
	--Form to Select Level
	levelSelect = forms.newform(100, 150, "Level Select")
	ice = forms.checkbox(levelSelect, "Iceman", 5, 20)
	fire = forms.checkbox(levelSelect, "Fireman", 5, 45)

	--Wait for a Level to Be Selected
	while (not (forms.ischecked(fire) or forms.ischecked(ice))) do
		emu.frameadvance()
	end

	if (forms.ischecked(fire)) then
		level = "FIRE"
	elseif (forms.ischecked(ice)) then
		level = "ICE"
	end

	forms.destroy(levelSelect)
	--End of Level Select

	Filename = "MegaMan_" .. level .. ".State"
	writePath = ".\\MegaMan_" .. level .. "\\Case_" .. caseNum .. "\\"

	--Timeout Determination based on Test Case
	if (caseNum == 1) then
		TimeoutConstant = 300
	elseif (caseNum == 2) then
		TimeoutConstant = 80
	end

elseif (gameinfo.getromname() == "Captain SkyHawk") then
	Filename = "Skyhawk.State"
	caseNum = 1
	TimeoutConstant = 300
	writePath = ".\\Captain Skyhawk\\Case_1\\"
	--No Timeout, Always Flying
end
--End Game Initial Configs
--====================================================================

ButtonNames = {
		"A",
		"B",
		"Up",
		"Down",
		"Left",
		"Right",
}

BoxRadius = 6
--Changed Input Size
InputSize = (BoxRadius*2+1)*(BoxRadius*2+1)
Inputs = memory.getmemorydomainsize("RAM") - 1
Outputs = #ButtonNames
score = 0
bestCount = 1

Population = 300
DeltaDisjoint = 2.0
DeltaWeights = 0.4
DeltaThreshold = 1.0

StaleSpecies = 15

MutateConnectionsChance = 0.25
PerturbChance = 0.90
CrossoverChance = 0.75
LinkMutationChance = 2.0
NodeMutationChance = 0.50
BiasMutationChance = 0.40
StepSize = 0.1
DisableMutationChance = 0.4
EnableMutationChance = 0.2

MaxNodes = 1000000
---------------------------------------------------------------------------------------------------------------------------
function lifeLost()
	if (gameinfo.getromname() == "Super Mario Bros.") then
		return memory.readbyte(0x075A) < 2
	elseif (gameinfo.getromname() == "Super Mario Bros. 3") then
		return memory.readbyte(0x0736) < 4
	elseif (gameinfo.getromname() == "Pac-Man") then
		return memory.readbyte(0x0067) < 3
	elseif (gameinfo.getromname() == "Mega Man") then
		return memory.readbyte(0x00A6) < 2
	elseif (gameinfo.getromname() == "Captain SkyHawk") then
		return memory.readbyte(0x0002) < 5
	end
end

function timedOut(timeoutBonus)
	if (gameinfo.getromname() == "Captain SkyHawk") then
		return false
	else
		return timeout + timeoutBonus <= 0
	end
end

function getMarioX()
	if gameinfo.getromname() == "Super Mario World (USA)" then
		marioX = memory.read_s16_le(0x94)
		
	elseif gameinfo.getromname() == "Super Mario Bros." then
		return memory.readbyte(0x6D) * 0x100 + memory.readbyte(0x86)
		
	elseif gameinfo.getromname() == "Super Mario Bros. 3" then
		return memory.readbyte(0x75) * 0x100 + memory.readbyte(0x90)
	end
end

function getMegaManX()
	return memory.readbyte(0x0460) * 0x100 + memory.readbyte(0x0480)
end

function calculateScore()
	local curScore = 0
	if gameinfo.getromname() == "Super Mario Bros." then
		curScore = curScore + memory.readbyte(0x07DE) * 100000 
		curScore = curScore + memory.readbyte(0x07DF) * 10000 
		curScore = curScore + memory.readbyte(0x07E0) * 1000 
		curScore = curScore + memory.readbyte(0x07E1) * 100 
		curScore = curScore + memory.readbyte(0x07E2) * 10 
	elseif gameinfo.getromname() == "Super Mario Bros. 3" then
		curScore = ((memory.readbyte(0x0716) * 255) + (memory.readbyte(0x0717) + 1)) * 10
	elseif gameinfo.getromname() == "Pac-Man" then
		curScore = curScore + memory.readbyte(0x0075) * 1000000
		curScore = curScore + memory.readbyte(0x0074) * 100000
		curScore = curScore + memory.readbyte(0x0073) * 10000
		curScore = curScore + memory.readbyte(0x0072) * 1000
		curScore = curScore + memory.readbyte(0x0071) * 100
		curScore = curScore + memory.readbyte(0x0070) * 10
	elseif gameinfo.getromname() == "Mega Man" then
		curScore = curScore + memory.readbyte(0x0078) * 1000000
		curScore = curScore + memory.readbyte(0x0077) * 100000
		curScore = curScore + memory.readbyte(0x0076) * 10000
		curScore = curScore + memory.readbyte(0x0075) * 1000
		curScore = curScore + memory.readbyte(0x0074) * 100
		curScore = curScore + memory.readbyte(0x0073) * 10
		curScore = curScore + memory.readbyte(0x0072)
	end

	return curScore
end

function pelletsEaten()
	--0x6A is remaining pellets, 192 is total pellets
	return 192 - memory.readbyte(0x006A)
end
-----------------------------------------------------------------------------------------------
function calculateFitness()
--Super Mario Bros. Fitness
	if (gameinfo.getromname() == "Super Mario Bros.") then
		if (caseNum == 1) then
			--Timeout 20
			local marX = getMarioX()
			if (marX > 3186) then
				return marX + 10000
			else
				return marX
			end

		elseif (caseNum == 2) then
			--Timeout 80
			local marX = getMarioX()
			if (marX > 3186) then
				return marX + 10000
			else
				return marX
			end

		elseif (caseNum == 3) then
			--Timeout 200
			return calculateScore()

		elseif (caseNum == 4) then
			--Timeout 100
			local marX = getMarioX()
			if (marX > 3186) then
				return (2.0 * marX) + 10000 + calculateScore()
			else
				return calculateScore() + (getMarioX() * 2.0)
			end
		end
--Super Mario Bros. 3 Fitness
	elseif (gameinfo.getromname() == "Super Mario Bros. 3") then
		if (caseNum == 1) then
			--Timeout 20
			local marX = getMarioX()
			if (marX == 8192) then
				console.writeline("Returning Previous: " .. prevFitness)
				return prevFitness
			elseif (marX > 2688) then
				return marX + 10000
			else
				return marX
			end

		elseif (caseNum == 2) then
			--Timeout 80
			local marX = getMarioX()
			if (marX == 8192) then
				return prevFitness
			elseif (marX > 2688) then
				return marX + 10000
			else
				return marX
			end

		elseif (caseNum == 3) then
			--Timeout 200
			return calculateScore()

		elseif (caseNum == 4) then
			--Timeout 100
			local marX = getMarioX()
			if (marX == 8192) then
				return prevFitness
			elseif (marX > 2688) then
				return (2.0 * marX) + 10000 + calculateScore()
			else
				return calculateScore() + (getMarioX() * 2.0)
			end
		end
--Pac-Man Fitness
	elseif (gameinfo.getromname()) == "Pac-Man" then
		if (caseNum == 1) then
			return pelletsEaten()

		elseif (caseNum == 2) then
			return calculateScore()

		elseif (caseNum == 3) then
			return (pelletsEaten() * 100) + calculateScore()
		end

	elseif (gameinfo.getromname() == "Mega Man") then
		megX = getMegaManX()
		if (caseNum == 1) then
			return calculateScore()
		elseif (caseNum == 2) then
			return calculateScore() + megX
		end
		prevMegX = megX

	elseif (gameinfo.getromname() == "Captain SkyHawk") then
		if (caseNum == 1) then
			return (300 * memory.readbyte(0x069C)) + pool.currentFrame
		end
	end
end

function getRAM()
	local inputs = {}
	--for i = 1,memory.getmemorydomainsize("RAM") do
	--	inputs[i] = memory.readbyte(0x0 + i)
		--table.insert(inputs, memory.readbyte(0x0 + i))
	--end
	--for k, v in pairs(inputs) do
	--	console.writeline("" .. k .. " " .. v)
	--end
	inputs = memory.readbyterange(0x0, memory.getmemorydomainsize("RAM") - 1, "RAM")
	return inputs
end


function sigmoid(x)
	return 2/(1+math.exp(-4.9*x))-1
end

function newInnovation()
	pool.innovation = pool.innovation + 1
	return pool.innovation
end

function newPool()
	local pool = {}
	pool.species = {}
	pool.generation = 0
	pool.innovation = Outputs
	pool.currentSpecies = 1
	pool.currentGenome = 1
	pool.currentFrame = 0
	pool.maxFitness = 0
	
	return pool
end

function newSpecies()
	local species = {}
	species.topFitness = 0
	species.staleness = 0
	species.genomes = {}
	species.averageFitness = 0
	
	return species
end

function newGenome()
	local genome = {}
	genome.genes = {}
	genome.fitness = 0
	genome.adjustedFitness = 0
	genome.network = {}
	genome.maxneuron = 0
	genome.globalRank = 0
	genome.mutationRates = {}
	genome.mutationRates["connections"] = MutateConnectionsChance
	genome.mutationRates["link"] = LinkMutationChance
	genome.mutationRates["bias"] = BiasMutationChance
	genome.mutationRates["node"] = NodeMutationChance
	genome.mutationRates["enable"] = EnableMutationChance
	genome.mutationRates["disable"] = DisableMutationChance
	genome.mutationRates["step"] = StepSize
	
	return genome
end

function copyGenome(genome)
	local genome2 = newGenome()
	for g=1,#genome.genes do
		table.insert(genome2.genes, copyGene(genome.genes[g]))
	end
	genome2.maxneuron = genome.maxneuron
	genome2.mutationRates["connections"] = genome.mutationRates["connections"]
	genome2.mutationRates["link"] = genome.mutationRates["link"]
	genome2.mutationRates["bias"] = genome.mutationRates["bias"]
	genome2.mutationRates["node"] = genome.mutationRates["node"]
	genome2.mutationRates["enable"] = genome.mutationRates["enable"]
	genome2.mutationRates["disable"] = genome.mutationRates["disable"]
	
	return genome2
end

function basicGenome()
	local genome = newGenome()
	local innovation = 1

	genome.maxneuron = Inputs
	mutate(genome)
	
	return genome
end

function newGene()
	local gene = {}
	gene.into = 0
	gene.out = 0
	gene.weight = 0.0
	gene.enabled = true
	gene.innovation = 0
	
	return gene
end

function copyGene(gene)
	local gene2 = newGene()
	gene2.into = gene.into
	gene2.out = gene.out
	gene2.weight = gene.weight
	gene2.enabled = gene.enabled
	gene2.innovation = gene.innovation
	
	return gene2
end

function newNeuron()
	local neuron = {}
	neuron.incoming = {}
	neuron.value = 0.0
	
	return neuron
end

function generateNetwork(genome)
	local network = {}
	network.neurons = {}
	for i=1,Inputs do
		network.neurons[i] = newNeuron()
	end	
	for o=1,Outputs do
		network.neurons[MaxNodes+o] = newNeuron()
	end
	table.sort(genome.genes, function (a,b)
		return (a.out < b.out)
	end)
	for i=1,#genome.genes do
		local gene = genome.genes[i]
		if gene.enabled then
			if network.neurons[gene.out] == nil then
				network.neurons[gene.out] = newNeuron()
			end
			local neuron = network.neurons[gene.out]
			table.insert(neuron.incoming, gene)
			if network.neurons[gene.into] == nil then
				network.neurons[gene.into] = newNeuron()
			end
		end
	end
	
	genome.network = network
end

function evaluateNetwork(network, inputs)
	--table.insert(inputs, 1)
	--if #inputs ~= Inputs then
	--	console.writeline("Incorrect number of neural network inputs.")
	--	return {}
	--end
	for i=1,#network.neurons - 1 do
		--console.writeline("" .. i .. " " .. inputs[i] .. "|| #network.neurons: " .. #network.neurons)
		if (network.neurons[i] == nil) then
			--console.writeline(i .." neuron is nil")
		elseif (network.neurons[i].value == nil) then
			--console.writeline(i .." neuron value is nil")
		elseif (inputs[i] == nil) then
			--console.writeline(i .. " inputs value is nil")
		else
			network.neurons[i].value = inputs[i]
		end
	end
	
	for _,neuron in pairs(network.neurons) do
		local sum = 0
		for j = 1,#neuron.incoming do
			local incoming = neuron.incoming[j]
			local other = network.neurons[incoming.into]
			if incoming.weight == nil then
				--console.writeline(j .. ": incoming weight is nil")
			
			elseif other.value == nil then
				--console.writeline(j .. ": other.value is nil")
			else
				sum = sum + incoming.weight * other.value
			end
		end
		
		if #neuron.incoming > 0 then
			neuron.value = sigmoid(sum)
		end
	end
	
	local outputs = {}
	for o=1,Outputs do
		local button = "P1 " .. ButtonNames[o]
		if network.neurons[MaxNodes+o].value > 0 then
			outputs[button] = true
		else
			outputs[button] = false
		end
	end
	
	return outputs
end

function crossover(g1, g2)
	-- Make sure g1 is the higher fitness genome
	if g2.fitness > g1.fitness then
		tempg = g1
		g1 = g2
		g2 = tempg
	end

	local child = newGenome()
	
	local innovations2 = {}
	for i=1,#g2.genes do
		local gene = g2.genes[i]
		innovations2[gene.innovation] = gene
	end
	
	for i=1,#g1.genes do
		local gene1 = g1.genes[i]
		local gene2 = innovations2[gene1.innovation]
		if gene2 ~= nil and math.random(2) == 1 and gene2.enabled then
			table.insert(child.genes, copyGene(gene2))
		else
			table.insert(child.genes, copyGene(gene1))
		end
	end
	
	child.maxneuron = math.max(g1.maxneuron,g2.maxneuron)
	
	for mutation,rate in pairs(g1.mutationRates) do
		child.mutationRates[mutation] = rate
	end
	
	return child
end

function randomNeuron(genes, nonInput)
	local neurons = {}
	if not nonInput then
		for i=1,Inputs do
			neurons[i] = true
		end
	end
	for o=1,Outputs do
		neurons[MaxNodes+o] = true
	end
	for i=1,#genes do
		if (not nonInput) or genes[i].into > Inputs then
			neurons[genes[i].into] = true
		end
		if (not nonInput) or genes[i].out > Inputs then
			neurons[genes[i].out] = true
		end
	end

	local count = 0
	for _,_ in pairs(neurons) do
		count = count + 1
	end
	local n = math.random(1, count)
	
	for k,v in pairs(neurons) do
		n = n-1
		if n == 0 then
			return k
		end
	end
	
	return 0
end

function containsLink(genes, link)
	for i=1,#genes do
		local gene = genes[i]
		if gene.into == link.into and gene.out == link.out then
			return true
		end
	end
end

function pointMutate(genome)
	local step = genome.mutationRates["step"]
	
	for i=1,#genome.genes do
		local gene = genome.genes[i]
		if math.random() < PerturbChance then
			gene.weight = gene.weight + math.random() * step*2 - step
		else
			gene.weight = math.random()*4-2
		end
	end
end

function linkMutate(genome, forceBias)
	local neuron1 = randomNeuron(genome.genes, false)
	local neuron2 = randomNeuron(genome.genes, true)
	 
	local newLink = newGene()
	if neuron1 <= Inputs and neuron2 <= Inputs then
		--Both input nodes
		return
	end
	if neuron2 <= Inputs then
		-- Swap output and input
		local temp = neuron1
		neuron1 = neuron2
		neuron2 = temp
	end

	newLink.into = neuron1
	newLink.out = neuron2
	if forceBias then
		newLink.into = Inputs
	end
	
	if containsLink(genome.genes, newLink) then
		return
	end
	newLink.innovation = newInnovation()
	newLink.weight = math.random()*4-2
	
	table.insert(genome.genes, newLink)
end

function nodeMutate(genome)
	if #genome.genes == 0 then
		return
	end

	genome.maxneuron = genome.maxneuron + 1

	local gene = genome.genes[math.random(1,#genome.genes)]
	if not gene.enabled then
		return
	end
	gene.enabled = false
	
	local gene1 = copyGene(gene)
	gene1.out = genome.maxneuron
	gene1.weight = 1.0
	gene1.innovation = newInnovation()
	gene1.enabled = true
	table.insert(genome.genes, gene1)
	
	local gene2 = copyGene(gene)
	gene2.into = genome.maxneuron
	gene2.innovation = newInnovation()
	gene2.enabled = true
	table.insert(genome.genes, gene2)
end

function enableDisableMutate(genome, enable)
	local candidates = {}
	for _,gene in pairs(genome.genes) do
		if gene.enabled == not enable then
			table.insert(candidates, gene)
		end
	end
	
	if #candidates == 0 then
		return
	end
	
	local gene = candidates[math.random(1,#candidates)]
	gene.enabled = not gene.enabled
end

function mutate(genome)
	for mutation,rate in pairs(genome.mutationRates) do
		if math.random(1,2) == 1 then
			genome.mutationRates[mutation] = 0.95*rate
		else
			genome.mutationRates[mutation] = 1.05263*rate
		end
	end

	if math.random() < genome.mutationRates["connections"] then
		pointMutate(genome)
	end
	
	local p = genome.mutationRates["link"]
	while p > 0 do
		if math.random() < p then
			linkMutate(genome, false)
		end
		p = p - 1
	end

	p = genome.mutationRates["bias"]
	while p > 0 do
		if math.random() < p then
			linkMutate(genome, true)
		end
		p = p - 1
	end
	
	p = genome.mutationRates["node"]
	while p > 0 do
		if math.random() < p then
			nodeMutate(genome)
		end
		p = p - 1
	end
	
	p = genome.mutationRates["enable"]
	while p > 0 do
		if math.random() < p then
			enableDisableMutate(genome, true)
		end
		p = p - 1
	end

	p = genome.mutationRates["disable"]
	while p > 0 do
		if math.random() < p then
			enableDisableMutate(genome, false)
		end
		p = p - 1
	end
end

function disjoint(genes1, genes2)
	local i1 = {}
	for i = 1,#genes1 do
		local gene = genes1[i]
		i1[gene.innovation] = true
	end

	local i2 = {}
	for i = 1,#genes2 do
		local gene = genes2[i]
		i2[gene.innovation] = true
	end
	
	local disjointGenes = 0
	for i = 1,#genes1 do
		local gene = genes1[i]
		if not i2[gene.innovation] then
			disjointGenes = disjointGenes+1
		end
	end
	
	for i = 1,#genes2 do
		local gene = genes2[i]
		if not i1[gene.innovation] then
			disjointGenes = disjointGenes+1
		end
	end
	
	local n = math.max(#genes1, #genes2)
	
	return disjointGenes / n
end

function weights(genes1, genes2)
	local i2 = {}
	for i = 1,#genes2 do
		local gene = genes2[i]
		i2[gene.innovation] = gene
	end

	local sum = 0
	local coincident = 0
	for i = 1,#genes1 do
		local gene = genes1[i]
		if i2[gene.innovation] ~= nil then
			local gene2 = i2[gene.innovation]
			sum = sum + math.abs(gene.weight - gene2.weight)
			coincident = coincident + 1
		end
	end
	
	return sum / coincident
end
	
function sameSpecies(genome1, genome2)
	local dd = DeltaDisjoint*disjoint(genome1.genes, genome2.genes)
	local dw = DeltaWeights*weights(genome1.genes, genome2.genes) 
	return dd + dw < DeltaThreshold
end

function rankGlobally()
	local global = {}
	for s = 1,#pool.species do
		local species = pool.species[s]
		for g = 1,#species.genomes do
			table.insert(global, species.genomes[g])
		end
	end
	table.sort(global, function (a,b)
		return (a.fitness < b.fitness)
	end)
	
	for g=1,#global do
		global[g].globalRank = g
	end
end

function calculateAverageFitness(species)
	local total = 0
	
	for g=1,#species.genomes do
		local genome = species.genomes[g]
		total = total + genome.globalRank
	end
	
	species.averageFitness = total / #species.genomes
end

function totalAverageFitness()
	local total = 0
	for s = 1,#pool.species do
		local species = pool.species[s]
		total = total + species.averageFitness
	end

	return total
end

function cullSpecies(cutToOne)
	for s = 1,#pool.species do
		local species = pool.species[s]
		
		table.sort(species.genomes, function (a,b)
			return (a.fitness > b.fitness)
		end)
		
		local remaining = math.ceil(#species.genomes/2)
		if cutToOne then
			remaining = 1
		end
		while #species.genomes > remaining do
			table.remove(species.genomes)
		end
	end
end

function breedChild(species)
	local child = {}
	if math.random() < CrossoverChance then
		g1 = species.genomes[math.random(1, #species.genomes)]
		g2 = species.genomes[math.random(1, #species.genomes)]
		child = crossover(g1, g2)
	else
		g = species.genomes[math.random(1, #species.genomes)]
		child = copyGenome(g)
	end
	
	mutate(child)
	
	return child
end

function removeStaleSpecies()
	local survived = {}

	for s = 1,#pool.species do
		local species = pool.species[s]
		
		table.sort(species.genomes, function (a,b)
			return (a.fitness > b.fitness)
		end)
		
		if species.genomes[1].fitness > species.topFitness then
			species.topFitness = species.genomes[1].fitness
			species.staleness = 0
		else
			species.staleness = species.staleness + 1
		end
		if species.staleness < StaleSpecies or species.topFitness >= pool.maxFitness then
			table.insert(survived, species)
		end
	end

	pool.species = survived
end

function removeWeakSpecies()
	local survived = {}

	local sum = totalAverageFitness()
	for s = 1,#pool.species do
		local species = pool.species[s]
		breed = math.floor(species.averageFitness / sum * Population)
		if breed >= 1 then
			table.insert(survived, species)
		end
	end

	pool.species = survived
end


function addToSpecies(child)
	local foundSpecies = false
	for s=1,#pool.species do
		local species = pool.species[s]
		if not foundSpecies and sameSpecies(child, species.genomes[1]) then
			table.insert(species.genomes, child)
			foundSpecies = true
		end
	end
	
	if not foundSpecies then
		local childSpecies = newSpecies()
		table.insert(childSpecies.genomes, child)
		table.insert(pool.species, childSpecies)
	end
end

function newGeneration()
	cullSpecies(false) -- Cull the bottom half of each species
	rankGlobally()
	removeStaleSpecies()
	rankGlobally()
	for s = 1,#pool.species do
		local species = pool.species[s]
		calculateAverageFitness(species)
	end
	removeWeakSpecies()
	local sum = totalAverageFitness()
	local children = {}
	for s = 1,#pool.species do
		local species = pool.species[s]
		breed = math.floor(species.averageFitness / sum * Population) - 1
		for i=1,breed do
			table.insert(children, breedChild(species))
		end
	end
	cullSpecies(true) -- Cull all but the top member of each species
	while #children + #pool.species < Population do
		local species = pool.species[math.random(1, #pool.species)]
		table.insert(children, breedChild(species))
	end
	for c=1,#children do
		local child = children[c]
		addToSpecies(child)
	end
	
	pool.generation = pool.generation + 1
	
	writeFile(writePath .. "Gen_" .. pool.generation .. ".pool")
end
	
function initializePool()
	pool = newPool()

	for i=1,Population do
		basic = basicGenome()
		addToSpecies(basic)
	end

	initializeRun()
end

function clearJoypad()
	controller = {}
	for b = 1,#ButtonNames do
		controller["P1 " .. ButtonNames[b]] = false
	end
	joypad.set(controller)
end

function initializeRun()
	savestate.load(Filename);
	curMaxFitness = 0
	pool.currentFrame = 0
	timeout = TimeoutConstant
	clearJoypad()
	
	local species = pool.species[pool.currentSpecies]
	local genome = species.genomes[pool.currentGenome]
	generateNetwork(genome)
	evaluateCurrent()
end

function evaluateCurrent()
	local species = pool.species[pool.currentSpecies]
	local genome = species.genomes[pool.currentGenome]

	--inputs = getInputs()
	inputs = getRAM()
	controller = evaluateNetwork(genome.network, inputs)
	
	if controller["P1 Left"] and controller["P1 Right"] then
		controller["P1 Left"] = false
		controller["P1 Right"] = false
	end
	if controller["P1 Up"] and controller["P1 Down"] then
		controller["P1 Up"] = false
		controller["P1 Down"] = false
	end

	joypad.set(controller)
end

if pool == nil then
	initializePool()
end


function nextGenome()
	pool.currentGenome = pool.currentGenome + 1
	if pool.currentGenome > #pool.species[pool.currentSpecies].genomes then
		pool.currentGenome = 1
		pool.currentSpecies = pool.currentSpecies+1
		if pool.currentSpecies > #pool.species then
			newGeneration()
			pool.currentSpecies = 1
		end
	end
end

function fitnessAlreadyMeasured()
	local species = pool.species[pool.currentSpecies]
	local genome = species.genomes[pool.currentGenome]
	
	return genome.fitness ~= 0
end


function writeFile(filename)
    local file, err = io.open(filename, "w+")
    if(file == nil) then
    	print("Couldn't open file: " .. err)
    end
	file:write(pool.generation .. "\n")
	file:write(pool.maxFitness .. "\n")
	file:write(#pool.species .. "\n")
        for n,species in pairs(pool.species) do
		file:write(species.topFitness .. "\n")
		file:write(species.staleness .. "\n")
		file:write(#species.genomes .. "\n")
		for m,genome in pairs(species.genomes) do
			file:write(genome.fitness .. "\n")
			file:write(genome.maxneuron .. "\n")
			for mutation,rate in pairs(genome.mutationRates) do
				file:write(mutation .. "\n")
				file:write(rate .. "\n")
			end
			file:write("done\n")
			
			file:write(#genome.genes .. "\n")
			for l,gene in pairs(genome.genes) do
				file:write(gene.into .. " ")
				file:write(gene.out .. " ")
				file:write(gene.weight .. " ")
				file:write(gene.innovation .. " ")
				if(gene.enabled) then
					file:write("1\n")
				else
					file:write("0\n")
				end
			end
		end
        end
        file:close()
end

function savePool()
	local filename = forms.gettext(saveLoadFile)
	writeFile(writePath .. filename .. ".pool")
end

function loadFile(filename)
	local file = io.open(filename, "r")
	if (file == nil) then
		console.log("Could not open file")
	else
		pool = newPool()
		pool.generation = file:read("*number")
		--bestCount = file:read("*number")
		pool.maxFitness = file:read("*number")
		forms.settext(maxFitnessLabel, "Max Fitness: " .. math.floor(pool.maxFitness))
	        local numSpecies = file:read("*number")
	        for s=1,numSpecies do
			local species = newSpecies()
			table.insert(pool.species, species)
			species.topFitness = file:read("*number")
			species.staleness = file:read("*number")
			local numGenomes = file:read("*number")
			for g=1,numGenomes do
				local genome = newGenome()
				table.insert(species.genomes, genome)
				genome.fitness = file:read("*number")
				genome.maxneuron = file:read("*number")
				local line = file:read("*line")
				while line ~= "done" do
					genome.mutationRates[line] = file:read("*number")
					line = file:read("*line")
				end
				local numGenes = file:read("*number")
				for n=1,numGenes do
					local gene = newGene()
					table.insert(genome.genes, gene)
					local enabled
					gene.into, gene.out, gene.weight, gene.innovation, enabled = file:read("*number", "*number", "*number", "*number", "*number")
					if enabled == 0 then
						gene.enabled = false
					else
						gene.enabled = true
					end
					
				end
			end
		end
	    file:close()
		
		while fitnessAlreadyMeasured() do
			nextGenome()
		end
		initializeRun()
		pool.currentFrame = pool.currentFrame + 1
	end
end
 
function loadPool()
	local filename = forms.gettext(saveLoadFile)
	loadFile(writePath .. filename .. ".pool")
end

function playTop()
	local maxfitness = 0
	local maxs, maxg
	for s,species in pairs(pool.species) do
		for g,genome in pairs(species.genomes) do
			if genome.fitness > maxfitness then
				maxfitness = genome.fitness
				maxs = s
				maxg = g
			end
		end
	end
	
	pool.currentSpecies = maxs
	pool.currentGenome = maxg
	pool.maxFitness = maxfitness
	forms.settext(maxFitnessLabel, "Max Fitness: " .. math.floor(pool.maxFitness))
	initializeRun()
	pool.currentFrame = pool.currentFrame + 1
	return
end

function onExit()
	forms.destroy(form)
end

writeFile(writePath .. "temp.pool")

event.onexit(onExit)

form = forms.newform(200, 260, "Fitness")
maxFitnessLabel = forms.label(form, "Max Fitness: " .. math.floor(pool.maxFitness), 5, 8)
--showNetwork = forms.checkbox(form, "Show Map", 5, 30)
caseDisplay = forms.label(form, "Case " .. caseNum, 5, 30)
if (gameinfo.getromname() == "Mega Man") then
	levelDisplay = forms.label(form, level .. "MAN", 5, 52)
end
restartButton = forms.button(form, "Restart", initializePool, 5, 77)
saveButton = forms.button(form, "Save", savePool, 5, 102)
loadButton = forms.button(form, "Load", loadPool, 80, 102)
saveLoadFile = forms.textbox(form, "", 170, 25, nil, 5, 148)
saveLoadLabel = forms.label(form, "Save/Load:", 5, 129)
playTopButton = forms.button(form, "Play Top", playTop, 5, 170)
hideBanner = forms.checkbox(form, "Hide Banner", 5, 190)

--bestCount = 0
prevFitness = -1


--Main Method
while true do
	local backgroundColor = 0xD0FFFFFF
	if not forms.ischecked(hideBanner) then
		gui.drawBox(0, 0, 300, 26, backgroundColor, backgroundColor)
	end

	local species = pool.species[pool.currentSpecies]
	local genome = species.genomes[pool.currentGenome]
	
	if pool.currentFrame%5 == 0 then
		evaluateCurrent()
	end

	joypad.set(controller)

	curFitness = calculateFitness()

	if curFitness > curMaxFitness then
		curMaxFitness = curFitness
		timeout = TimeoutConstant
	end
	
	timeout = timeout - 1
	
	
	local timeoutBonus = pool.currentFrame / 4
	if timedOut(timeoutBonus) or lifeLost() then
------------------------------------FITNESS CODE---------------------------------------------
		local fitness = curMaxFitness
		
		if fitness == 0 then
			fitness = -1
		end
		genome.fitness = fitness
		
		if fitness > pool.maxFitness then
			pool.maxFitness = fitness
			bestCount = bestCount + 1
			forms.settext(maxFitnessLabel, "Max Fitness: " .. math.floor(pool.maxFitness))
		end

		if(gameinfo.getromname() == "Super Mario Bros. 3" or gameinfo.getromname() == "Super Mario Bros.") then
			console.writeline("Gen " .. pool.generation .. " species " .. pool.currentSpecies .. " genome " .. pool.currentGenome .. " fitness: " .. fitness .. "| marioX: " .. getMarioX())
		else
			console.writeline("Gen " .. pool.generation .. " species " .. pool.currentSpecies .. " genome " .. pool.currentGenome .. " fitness: " .. fitness)
		end
		pool.currentSpecies = 1
		pool.currentGenome = 1
		while fitnessAlreadyMeasured() do
			nextGenome()
		end
		initializeRun()
	end

	local measured = 0
	local total = 0
	for _,species in pairs(pool.species) do
		for _,genome in pairs(species.genomes) do
			total = total + 1
			if genome.fitness ~= 0 then
				measured = measured + 1
			end
		end
	end
	if not forms.ischecked(hideBanner) then
		gui.drawText(0, 6, "Gen " .. pool.generation .. " species " .. pool.currentSpecies .. " genome " .. pool.currentGenome .. " (" .. math.floor(measured/total*100) .. "%)", 0xFF000000, 6, 11)
		gui.drawText(0, 16, "Fitness: " .. math.floor(curMaxFitness) .. "| Case Number: " .. caseNum, 0xFF000000, 6, 11)		
	end
		
	pool.currentFrame = pool.currentFrame + 1
	prevFitness = curFitness

	emu.frameadvance();
end
