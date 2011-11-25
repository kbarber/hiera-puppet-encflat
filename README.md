This is an alternative to the puppet backend that allows the
searching of flat variables that are often used in ENCs that
do not yet support parameterized classes (Dashboard and 
Foreman for example).

This means when you do this:

    class my_class (
      $var1 = hiera("var1")
    ) {
      notify { "value is": message => $var1 }
    }

It will do the lookup in the following order:

    $my_class_var1

Or with sub-classes:

    class my_class::sub (
      $var1 = hiera("var1")
    ) {
      notify { "value is": message => $var1 }
    }

It will lookup:

    $my_class_sub_var1
    $my_class_var1

If you mix this with the traditional Puppet backend, you also
get the ability to look at a params/data classes as well which
when combined means the previous lookup would use:

    $my_class_sub_var1
    $my_class_var1
    $my_class::sub::data::var1
    $my_class::data::var1
    $data::common::var1

The whole point of this is so I can have an Dashboard or Foreman
params with global namespacing mixed with other hiera lookups (and
even param class overrides).
