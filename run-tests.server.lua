local TestEz = require(game.ReplicatedStorage.TestEz)

local tests = {
	game.ReplicatedStorage
}

TestEz.TestBootstrap:run(tests, TestEz.Reporters.TextReporterQuiet)
