KloudGenTest1 : UnitTest {
	test_check_classname {
		var result = KloudGen.new;
		this.assert(result.class == KloudGen);
	}
}


KloudGenTester {
	*new {
		^super.new.init();
	}

	init {
		KloudGenTest1.run;
	}
}
