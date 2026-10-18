class_name FoolPathway
extends RefCounted

const ID := &"fool"


static func create() -> BeyonderPathway:
	var pathway := BeyonderPathway.new()
	pathway.id = ID
	pathway.display_name = "Fool"
	pathway.description = "A pathway of divination, deception, and manipulation. Its Beyonders read fate, wear other people's faces, and pull the strings of others from behind the curtain, all at the constant risk of losing themselves."
	pathway.uniqueness = "Uniqueness of the Fool"
	pathway.sefirah = "Sefirah Castle"
	pathway.neighboring_pathways = [&"door", &"error"]
	pathway.sequences = [
		_seer(),
		_clown(),
		_magician(),
		_faceless(),
		_marionettist(),
		_bizarro_sorcerer(),
		_scholar_of_yore(),
		_miracle_invoker(),
		_attendant_of_mysteries(),
		_the_fool(),
	]
	return pathway


static func _sequence(number: int, display_name: String, description: String, acting_principle := "") -> BeyonderSequence:
	var sequence := BeyonderSequence.new()
	sequence.number = number
	sequence.display_name = display_name
	sequence.description = description
	sequence.acting_principle = acting_principle
	return sequence


static func _seer() -> BeyonderSequence:
	var s := _sequence(9, "Seer",
		"A mystic who glimpses fate through rituals and symbols. Physically ordinary, but spiritually sharp and well-versed in occult knowledge.",
		"A Seer must never truly believe they see everything. Observe, interpret, and guide others without being swallowed by the answers.")
	s.stat_bonuses = {&"spirituality": 20.0, &"perception": 5.0, &"mental_resistance": 3.0}
	s.abilities = [
		BeyonderAbility.make(&"spirit_vision", "Spirit Vision",
			"Toggle sight of auras, colors of emotion and health, and lingering spirits. Drains spirituality while active.",
			false, 1.0, 0.0, 15.0),
		BeyonderAbility.make(&"divination", "Divination",
			"Seek answers through a pendulum, dowsing rod, tarot, astrology, or dream divination. Vaguer and riskier for powerful targets.",
			false, 8.0, 30.0),
		BeyonderAbility.make(&"danger_intuition", "Danger Intuition",
			"A faint warning before imminent harm.", true),
		BeyonderAbility.make(&"mysticism_knowledge", "Mysticism Knowledge",
			"Understands rituals, symbols, and occult correspondences.", true),
	]
	return s


static func _clown() -> BeyonderSequence:
	var s := _sequence(8, "Clown",
		"The body catches up with the spirit. Balance, agility, and reflexes rise sharply, and the face becomes a perfectly controlled mask.",
		"A Clown smiles while crying. Keep calm and hide real emotions behind the performance, no matter what is felt inside.")
	s.stat_bonuses = {&"physique": 8.0, &"agility": 12.0, &"spirituality": 5.0, &"mental_resistance": 3.0}
	s.abilities = [
		BeyonderAbility.make(&"clown_physique", "Clown's Body",
			"Superior balance, flexibility, and control over every muscle, including facial expressions.", true),
		BeyonderAbility.make(&"paper_daggers", "Paper Daggers",
			"Throw cards or sheets of paper with enough force and precision to cut like steel.",
			false, 2.0, 1.0, 20.0),
		BeyonderAbility.make(&"combat_intuition", "Combat Intuition",
			"Danger Intuition sharpens into split-second reactions during a fight.", true),
	]
	return s


static func _magician() -> BeyonderSequence:
	var s := _sequence(7, "Magician",
		"A performer whose tricks are real. Commands flame, air, and paper to deceive, escape, and strike.",
		"A Magician's art is deception. Every trick must mislead the audience: show them one thing while doing another.")
	s.stat_bonuses = {&"spirituality": 15.0, &"agility": 5.0, &"mental_resistance": 4.0}
	s.abilities = [
		BeyonderAbility.make(&"flame_jumping", "Flame Jumping",
			"Step into one fire and out of another within range.",
			false, 10.0, 3.0, 50.0),
		BeyonderAbility.make(&"flame_control", "Flame Control",
			"Ignite and shape flames into darts or spears.",
			false, 6.0, 2.0, 25.0),
		BeyonderAbility.make(&"air_bullet", "Air Bullet",
			"Snap your fingers to fire a compressed bullet of air.",
			false, 3.0, 0.5, 30.0),
		BeyonderAbility.make(&"paper_figurine_substitute", "Paper Figurine Substitute",
			"A prepared paper figurine takes a fatal blow in your place while you reappear nearby.",
			false, 15.0, 10.0, 5.0),
		BeyonderAbility.make(&"underwater_breathing", "Underwater Breathing",
			"Conjure a pipe of air to breathe while submerged.",
			false, 2.0),
		BeyonderAbility.make(&"illusion", "Minor Illusion",
			"Create brief visual illusions to misdirect observers.",
			false, 5.0, 5.0, 15.0),
	]
	return s


static func _faceless() -> BeyonderSequence:
	var s := _sequence(6, "Faceless",
		"The body itself becomes clay. Faces, builds, and voices can be reshaped at will to become anyone.",
		"A Faceless can become anyone but must never forget who they are. Every face worn is a role, and staying in it too long erases the actor.")
	s.stat_bonuses = {&"physique": 5.0, &"spirituality": 15.0, &"mental_resistance": 6.0}
	s.abilities = [
		BeyonderAbility.make(&"face_changing", "Face Changing",
			"Reshape face, height, build, and voice to match a person you have studied.",
			false, 12.0, 15.0),
		BeyonderAbility.make(&"perfect_disguise", "Perfect Disguise",
			"Mimic the mannerisms and habits of the face you wear. Holding a face too long risks losing yourself.", true),
		BeyonderAbility.make(&"body_reshaping", "Body Reshaping",
			"Shift bones and muscles to slip restraints or dodge blows.",
			false, 6.0, 4.0),
	]
	return s


static func _marionettist() -> BeyonderSequence:
	var s := _sequence(5, "Marionettist",
		"Sees the Spirit Body Threads binding every living thing and can seize them, slowly turning people into puppets.",
		"A Marionettist controls from behind the scenes. Stay hidden, let the marionettes take the stage, and remember that someone may be holding your strings too.")
	s.stat_bonuses = {&"spirituality": 25.0, &"perception": 8.0, &"mental_resistance": 8.0}
	s.abilities = [
		BeyonderAbility.make(&"spirit_body_threads", "Spirit Body Threads",
			"See the threads that bind creatures' spirit bodies within range.",
			true, 0.0, 0.0, 100.0),
		BeyonderAbility.make(&"thread_control", "Thread Control",
			"Seize a creature's threads to slow and freeze it. Holding on long enough turns it into a marionette.",
			false, 4.0, 0.0, 100.0),
		BeyonderAbility.make(&"marionette_manipulation", "Marionette Manipulation",
			"Command marionettes, including any Beyonder powers they had.",
			false, 2.0, 0.0, 100.0),
		BeyonderAbility.make(&"marionette_substitution", "Marionette Substitution",
			"Swap places with one of your marionettes to escape an attack.",
			false, 10.0, 8.0, 100.0),
	]
	return s


static func _bizarro_sorcerer() -> BeyonderSequence:
	return _sequence(4, "Bizarro Sorcerer",
		"A demigod whose body can unravel into worms of spirit. Travels through the spirit world and survives wounds that would kill others.")


static func _scholar_of_yore() -> BeyonderSequence:
	return _sequence(3, "Scholar of Yore",
		"Reaches into the Historical Void to summon projections of past people, items, and moments.")


static func _miracle_invoker() -> BeyonderSequence:
	return _sequence(2, "Miracle Invoker",
		"An angel who can make wishes come true, bending reality to grant miracles.")


static func _attendant_of_mysteries() -> BeyonderSequence:
	return _sequence(1, "Attendant of Mysteries",
		"Grafts concepts onto one another, joining things, distances, and ideas that should never connect.")


static func _the_fool() -> BeyonderSequence:
	return _sequence(0, "Fool",
		"The true god of the pathway, who dwells above the gray fog and holds dominion over deception, fate, and the spirit world.")
