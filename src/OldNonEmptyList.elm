module NonEmptyList exposing (NonEmptyList, fromList, head, uniform)


import Random


type NonEmptyList a
  = NonEmptyList a (List a)


fromList : a -> List a -> NonEmptyList a
fromList =
  NonEmptyList


head : NonEmptyList a -> a
head (NonEmptyList x _) =
  x


uniform : NonEmptyList a -> Random.Generator a
uniform (NonEmptyList x xs) =
  Random.uniform x xs
