import category_theory.category
import category_theory.isomorphism
import .article2
--import category_theory.types


namespace exercises

universe u

open category_theory

variables {α β: Type*}
variables [category α]

structure endomap (α : Type*) [category α] :=
(carrier : α)
(endo : carrier ⟶ carrier)

structure endomaps_map (dom: endomap α) (ima: endomap α) :=
(map : dom.carrier ⟶ ima.carrier)
(preserve : dom.endo ≫ map = map ≫ ima.endo)

-- Exercise 1 page 137
def endomap_maps_comp {A B C: endomap α} (f : endomaps_map A B) (g : endomaps_map B C) : endomaps_map A C :=
{
    map := f.map ≫ g.map,
    preserve :=
       calc A.endo ≫ f.map ≫ g.map = (f.map ≫ B.endo) ≫ g.map : by rw [← category.assoc, f.preserve]
            ... = f.map ≫ g.map ≫ C.endo : by simp [g.preserve]
            ... = (f.map ≫ g.map) ≫ C.endo : by simp,
}

variables {A B : endomap α}

@[simp]
lemma coe_mk (f : endomaps_map A  B) (pre) : (endomaps_map.mk f.map pre) = f := by {sorry}

lemma coe_inj ⦃f g : endomaps_map A B⦄ (h : (f : endomaps_map A B) = g) : f = g :=
begin
    cases f, cases g,
    exact h,
end

--@[ext]
--lemma endo_hom_ext ⦃f g : endomaps_map A B⦄ (h : ∀ x, f x = g x) : f = g :=
    --coe_inj _ _ (funext h)

instance endo_category : category (endomap α) :=
{
    hom := λ f g, endomaps_map f g,
    id := λ x, ⟨ 𝟙 x.carrier, by simp ⟩, 
    comp := λ _ _ _ f g, endomap_maps_comp f g,
    id_comp' := λ _ _ f, by {simp at *,unfold endomap_maps_comp,simp},
    comp_id' := λ _ _ f, by {simp at *,unfold endomap_maps_comp,simp},
    assoc'   := λ _ _ _ _ f g h, by {simp, unfold endomap_maps_comp, simp}
}

-- Exercise 2 page 139
example {X: α} (endo r : X ⟶ X) (idem : idempotent endo) (ret : is_retraction endo r) : endo = 𝟙 X :=
    calc endo = endo ≫ 𝟙 X : by simp
        ... = endo ≫ (endo ≫ r) : by {unfold is_retraction at ret, rw ←ret}
        ... = (endo ≫ endo) ≫ r : by simp
        ... = endo ≫ r : by rw idempotent.repeat
        ... = 𝟙 X : ret

-- Exercise 3 page 140


end exercises