#README#


Exercises + Application Assignments from Ruby Object Oriented Programming course 130

Core Concepts of 130:

i. Closures are chunks of code that can be saved, passed around, and executed later

ii. Closures maintain access to the variables, methods, and other artifacts initialized
    in the environment prior to the closure's initialization. This surrounding environment
    is referred to as the binding. The closure drags around its binding when its executed,
    which means that local variables and other items within the binding are accessible when
    the closure is executed.

iii. Closures are implemented as blocks, procs, and lambdas in Ruby.

iv. Arity is the rule about the number of arguments that have to be passed in when working
    with blocks, procs, lambdas, and methods based on the number of parameters these items
    are defined with. Arity doesn't apply to optional parameters.
      Lenient arity: can pass in fewer or more arguments than are expected and won't raise
        an exception. For example, if pass in fewer arguments than a block is defined to
        accept then those block local variables will point to nil. If pass in more arguments
        to a block, then the excess arguments will be ignored after all the block local
        variables are assigned to the respective values passed in.
         BLAP: Procs and Blocks have lenient arity
      Strict arity: can't pass in fewer or more arguments than are expected; if one does,
       then an exception will be raised
         SLAM: Lambdas and Methods have strict arity

v. Every method in Ruby can accept an optional block argument when the method is invoked,
   as long as that method is invoked with the correct number of arguments based on the
   number of parameters it was defined with. Whether the method uses the block argument
   passed in or ignores the block argument depends on how the method was defined.

vi. An optional block argument passed into a method doesn't have an explicit name. So,
    one cannot explicitly refer to the block within the method, but can still execute
    the block argument from within the method by using the yield keyword. If want the
    block argument to truly be optional, then need to include the yield keyword in a
    conditional that leverages the Kernel#block_given? method. This will avoid raising
    a LocalJumpError exception, as yield will only be executed if a block argument has
    been passed into the method.

vii. Methods can be defined to accept an explicit block argument, by including the '&' 
     character prior to a parameter name. The block will be converted into a 
     simple Proc object, so to call the block within the method, need to use the call
     method. Explicit blocks provide flexibility due to being able to explicitly call
     block by name; as a result of this, can pass a block argument into another method
     within the current method's body.

viii. Blocks have return values, just like methods. If there's no return keyword within
      the block then the block's return value will be the last expression evaluated.
      Blocks and methods can both return Procs and Lambdas, which allows for chaining 
      of calls.

ix. Blocks create inner scopes; inner scopes have access to local variables defined in
    outer scopes, but outer scopes do not have access to local variables defined within
    inner scopes.

x. Blocks have parameters, which are designated by the values between the '|' operators.
   Within the block, the variables designated by the block parameters are block local
   variables. The scope of a block local variable is constrained just to the block.

xi. Reasons for yielding to blocks within a method:
     (a) Defer implementation details to invocation, which allows for flexibility and
         reusability of code.
     (b) Perform some before and after action that occur before and after anything.
         The "anything" is specified by the person invoking the method. This can be useful
         for notification systems, logging things, timing things, and resource
         management/cleanup.

xii. Symbol#to_proc is a shortcut for passing in blocks to collection methods.
     Symbol#to_proc converts a symbol to a proc, which can then naturally be converted
     to a block and passed in to the respective collection method. This shortcut works
     as long as the method that the symbol corresponds to doesn't take an argument.
      Example: [1, 2, 3].map(&:to_f)

xiii. Minitest and RSpec can both be used to write tests that follow the SEAT approach; they
      differ in style.

xiv. Testing prevents regressions, which means it allows for checking that a program still
     functions after additional code has been incremented on without having to manually
     recheck everything.

xv. SEAT:
     S = Set-up the test, by instantiating any objects that will be used w/in test(s)
     E = Execute the code against the object(s)
     A = Assert the results of each execution
     T = Teardown & cleanup objects post testing

xv. Test = situation or context in which a verification check needs to be made. 

xvi. Assertions = declare the results of a verification by indicating whether the results
      matched expectations or not.

xvii. Test Suite = group of situations and contexts where a verification check is made.

xviii. Core Ruby tools = Ruby Version Managers, Gems, Bundler & Rake
    