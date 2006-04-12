(* This program is free software; you can redistribute it and/or      *)
(* modify it under the terms of the GNU Lesser General Public License *)
(* as published by the Free Software Foundation; either version 2.1   *)
(* of the License, or (at your option) any later version.             *)
(*                                                                    *)
(* This program is distributed in the hope that it will be useful,    *)
(* but WITHOUT ANY WARRANTY; without even the implied warranty of     *)
(* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the      *)
(* GNU General Public License for more details.                       *)
(*                                                                    *)
(* You should have received a copy of the GNU Lesser General Public   *)
(* License along with this program; if not, write to the Free         *)
(* Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA *)
(* 02110-1301 USA                                                     *)


Require Import Reals.
Require Import trajectory_const.
Require Import rrho.
Require Import trajectory_def.
Require Import constants.
Require Import ycngftys.
Require Import ycngstys.
Require Import ails_def.
Require Import math_prop.
Section alpha_no_conflict.

Require Import tau.
Require Import ails.
Require Import trajectory.
Require Import measure2state.
Require Import ails_trajectory.
Require Import alarm.

Variable intr : Trajectory.
Variable evad : EvaderTrajectory.
Variable T : TimeT.

Definition Alpha (a : R) : bool :=
  let a1 :=
    ((Rsqr (ve evad * T) + Rsqr (l intr evad T) - Rsqr AlertRange) /
     (2 * ve evad * T))%R in
  let a2 := (l intr evad T * cos a)%R in
  match Rle_dec a1 a2 with
  | left _ => true
  | right _ => false
  end.

Lemma Alpha_d_AlertRange_0 :
 Alpha (beta intr evad T) = true -> (d intr evad <= AlertRange)%R.
Proof with trivial.
unfold Alpha in |- *;
 case
  (Rle_dec
     ((Rsqr (ve evad * T) + Rsqr (l intr evad T) - Rsqr AlertRange) /
      (2 * ve evad * T)) (l intr evad T * cos (beta intr evad T))); 
 intros...
unfold Rdiv in r; cut (0 < 2 * ve evad * T)%R...
intro;
 generalize
  (Rmult_le_compat_r (2 * ve evad * T)
     ((Rsqr (ve evad * T) + Rsqr (l intr evad T) - Rsqr AlertRange) *
      / (2 * ve evad * T)) (l intr evad T * cos (beta intr evad T))
     (Rlt_le 0 (2 * ve evad * T) H0) r); repeat rewrite Rmult_assoc;
 rewrite <- Rinv_l_sym...
rewrite Rmult_1_r; intro;
 generalize
  (Rplus_le_compat_l
     (Rsqr AlertRange -
      2 * l intr evad T * ve evad * T * cos (beta intr evad T))
     (Rsqr (ve evad * T) + Rsqr (l intr evad T) - Rsqr AlertRange)
     (l intr evad T * (cos (beta intr evad T) * (2 * (ve evad * T)))) H1);
 replace
  (Rsqr AlertRange - 2 * l intr evad T * ve evad * T * cos (beta intr evad T) +
   l intr evad T * (cos (beta intr evad T) * (2 * (ve evad * T))))%R with
  (Rsqr AlertRange)...
replace
 (Rsqr AlertRange - 2 * l intr evad T * ve evad * T * cos (beta intr evad T) +
  (Rsqr (ve evad * T) + Rsqr (l intr evad T) - Rsqr AlertRange))%R with
 (Rsqr (ve evad * T) + Rsqr (l intr evad T) -
  2 * ve evad * T * l intr evad T * cos (beta intr evad T))%R...
rewrite <- d_l_beta...
intro; apply Rsqr_incr_0_var...
left; apply AlertRange_pos...
ring...
ring...
repeat apply prod_neq_R0...
discrR...
red in |- *; intro; generalize (TypeSpeed_pos (h (tr evad))); intro;
 unfold ve in H1; rewrite H1 in H2; elim (Rlt_irrefl 0 H2)...
cut (0 < T)%R...
intro...
red in |- *; intro; rewrite H2 in H1; elim (Rlt_irrefl 0 H1)...
apply Rlt_le_trans with MinT...
apply MinT_is_pos...
apply (cond_1 T)...
repeat apply Rmult_lt_0_compat...
prove_sup0...
unfold ve in |- *; apply (TypeSpeed_pos (h (tr evad)))...
apply Rlt_le_trans with MinT...
apply MinT_is_pos...
apply (cond_1 T)...
elim diff_false_true...
Qed.

Lemma Alpha_d_AlertRange_1 :
 (d intr evad <= AlertRange)%R -> Alpha (beta intr evad T) = true.
Proof with trivial.
intros; unfold Alpha in |- *;
 case
  (Rle_dec
     ((Rsqr (ve evad * T) + Rsqr (l intr evad T) - Rsqr AlertRange) /
      (2 * ve evad * T)) (l intr evad T * cos (beta intr evad T))); 
 intro...
elim n; unfold Rdiv in |- *; cut (0 < 2 * ve evad * T)%R...
intro; apply Rmult_le_reg_l with (2 * ve evad * T)%R...
rewrite <-
 (Rmult_comm
    ((Rsqr (ve evad * T) + Rsqr (l intr evad T) - Rsqr AlertRange) *
     / (2 * ve evad * T))); repeat rewrite Rmult_assoc; 
 rewrite <- Rinv_l_sym...
rewrite Rmult_1_r;
 apply
  Rplus_le_reg_l
   with
     (Rsqr AlertRange -
      2 * l intr evad T * ve evad * T * cos (beta intr evad T))%R;
 replace
  (Rsqr AlertRange - 2 * l intr evad T * ve evad * T * cos (beta intr evad T) +
   (Rsqr (ve evad * T) + Rsqr (l intr evad T) - Rsqr AlertRange))%R with
  (Rsqr (ve evad * T) + Rsqr (l intr evad T) -
   2 * ve evad * T * l intr evad T * cos (beta intr evad T))%R...
rewrite <- d_l_beta;
 replace
  (Rsqr AlertRange - 2 * l intr evad T * ve evad * T * cos (beta intr evad T) +
   2 * (ve evad * (T * (l intr evad T * cos (beta intr evad T)))))%R with
  (Rsqr AlertRange)...
apply Rsqr_incr_1...
unfold d in |- *; unfold Die in |- *; apply sqrt_positivity;
 apply Rplus_le_le_0_compat; apply Rle_0_sqr...
left; apply AlertRange_pos...
ring...
ring...
repeat apply prod_neq_R0...
discrR...
red in |- *; intro; generalize (TypeSpeed_pos (h (tr evad))); intro;
 unfold ve in H1; rewrite H1 in H2; elim (Rlt_irrefl 0 H2)...
cut (0 < T)%R...
intro; red in |- *; intro; rewrite H2 in H1; elim (Rlt_irrefl 0 H1)...
apply Rlt_le_trans with MinT...
apply MinT_is_pos...
apply (cond_1 T)...
repeat apply Rmult_lt_0_compat;
 [ prove_sup0
 | unfold ve in |- *; apply (TypeSpeed_pos (h (tr evad)))
 | apply Rlt_le_trans with MinT; [ apply MinT_is_pos | apply (cond_1 T) ] ]...
Qed.

Lemma Alpha_d_AlertRange_2 :
 Alpha (beta intr evad T) = false -> (AlertRange < d intr evad)%R.
Proof with trivial.
unfold Alpha in |- *;
 case
  (Rle_dec
     ((Rsqr (ve evad * T) + Rsqr (l intr evad T) - Rsqr AlertRange) /
      (2 * ve evad * T)) (l intr evad T * cos (beta intr evad T))); 
 intros...
elim diff_true_false...
unfold Rdiv in n; cut (0 < 2 * ve evad * T)%R...
intro...
cut
 (l intr evad T * cos (beta intr evad T) <
  (Rsqr (ve evad * T) + Rsqr (l intr evad T) - Rsqr AlertRange) *
  / (2 * ve evad * T))%R...
intro;
 generalize
  (Rmult_lt_compat_r (2 * ve evad * T)
     (l intr evad T * cos (beta intr evad T))
     ((Rsqr (ve evad * T) + Rsqr (l intr evad T) - Rsqr AlertRange) *
      / (2 * ve evad * T)) H0 H1); repeat rewrite Rmult_assoc;
 rewrite <- Rinv_l_sym...
rewrite Rmult_1_r; intro;
 generalize
  (Rplus_lt_compat_l
     (Rsqr AlertRange -
      2 * l intr evad T * ve evad * T * cos (beta intr evad T))
     (l intr evad T * (cos (beta intr evad T) * (2 * (ve evad * T))))
     (Rsqr (ve evad * T) + Rsqr (l intr evad T) - Rsqr AlertRange) H2);
 replace
  (Rsqr AlertRange - 2 * l intr evad T * ve evad * T * cos (beta intr evad T) +
   l intr evad T * (cos (beta intr evad T) * (2 * (ve evad * T))))%R with
  (Rsqr AlertRange)...
replace
 (Rsqr AlertRange - 2 * l intr evad T * ve evad * T * cos (beta intr evad T) +
  (Rsqr (ve evad * T) + Rsqr (l intr evad T) - Rsqr AlertRange))%R with
 (Rsqr (ve evad * T) + Rsqr (l intr evad T) -
  2 * ve evad * T * l intr evad T * cos (beta intr evad T))%R...
rewrite <- d_l_beta...
intro; apply Rsqr_incrst_0...
left; apply AlertRange_pos...
unfold d in |- *; unfold Die in |- *; apply sqrt_positivity;
 apply Rplus_le_le_0_compat; apply Rle_0_sqr...
ring...
ring...
repeat apply prod_neq_R0...
discrR...
red in |- *; intro; generalize (TypeSpeed_pos (h (tr evad))); intro;
 unfold ve in H2; rewrite H2 in H3; elim (Rlt_irrefl 0 H3)...
cut (0 < T)%R...
intro...
red in |- *; intro; rewrite H3 in H2; elim (Rlt_irrefl 0 H2)...
apply Rlt_le_trans with MinT...
apply MinT_is_pos...
apply (cond_1 T)...
auto with real...
repeat apply Rmult_lt_0_compat...
prove_sup0...
unfold ve in |- *; apply (TypeSpeed_pos (h (tr evad)))...
apply Rlt_le_trans with MinT...
apply MinT_is_pos...
apply (cond_1 T)...
Qed.

Lemma Alpha_d_AlertRange_3 :
 (AlertRange < d intr evad)%R -> Alpha (beta intr evad T) = false.
Proof with trivial.
intros; unfold Alpha in |- *;
 case
  (Rle_dec
     ((Rsqr (ve evad * T) + Rsqr (l intr evad T) - Rsqr AlertRange) /
      (2 * ve evad * T)) (l intr evad T * cos (beta intr evad T))); 
 intro...
unfold Rdiv in r; cut (0 < 2 * ve evad * T)%R...
intro;
 generalize
  (Rmult_le_compat_l (2 * ve evad * T)
     ((Rsqr (ve evad * T) + Rsqr (l intr evad T) - Rsqr AlertRange) *
      / (2 * ve evad * T)) (l intr evad T * cos (beta intr evad T))
     (Rlt_le 0 (2 * ve evad * T) H0) r)...
rewrite <-
 (Rmult_comm
    ((Rsqr (ve evad * T) + Rsqr (l intr evad T) - Rsqr AlertRange) *
     / (2 * ve evad * T))); repeat rewrite Rmult_assoc; 
 rewrite <- Rinv_l_sym...
rewrite Rmult_1_r; intro...
generalize
 (Rplus_le_compat_l
    (Rsqr AlertRange -
     2 * l intr evad T * ve evad * T * cos (beta intr evad T))
    (Rsqr (ve evad * T) + Rsqr (l intr evad T) - Rsqr AlertRange)
    (2 * (ve evad * (T * (l intr evad T * cos (beta intr evad T))))) H1)...
replace
 (Rsqr AlertRange - 2 * l intr evad T * ve evad * T * cos (beta intr evad T) +
  (Rsqr (ve evad * T) + Rsqr (l intr evad T) - Rsqr AlertRange))%R with
 (Rsqr (ve evad * T) + Rsqr (l intr evad T) -
  2 * ve evad * T * l intr evad T * cos (beta intr evad T))%R...
rewrite <- d_l_beta;
 replace
  (Rsqr AlertRange - 2 * l intr evad T * ve evad * T * cos (beta intr evad T) +
   2 * (ve evad * (T * (l intr evad T * cos (beta intr evad T)))))%R with
  (Rsqr AlertRange)...
intro...
generalize
 (Rsqr_incr_0_var (d intr evad) AlertRange H2
    (Rlt_le 0 AlertRange AlertRange_pos))...
intro...
elim (Rlt_irrefl (d intr evad) (Rle_lt_trans _ _ _ H3 H))...
ring...
ring...
repeat apply prod_neq_R0...
discrR...
red in |- *; intro; generalize (TypeSpeed_pos (h (tr evad))); intro;
 unfold ve in H1; rewrite H1 in H2; elim (Rlt_irrefl 0 H2)...
cut (0 < T)%R...
intro...
red in |- *; intro; rewrite H2 in H1; elim (Rlt_irrefl 0 H1)...
apply Rlt_le_trans with MinT...
apply MinT_is_pos...
apply (cond_1 T)...
repeat apply Rmult_lt_0_compat;
 [ prove_sup0
 | unfold ve in |- *; apply (TypeSpeed_pos (h (tr evad)))
 | apply Rlt_le_trans with MinT; [ apply MinT_is_pos | apply (cond_1 T) ] ]...
Qed.

(*** Verifiable in MuPAD ***)
Axiom
  cos_beta_NOT_Alpha :
    Alpha (beta intr evad T) = false ->
    h intr = V ->
    h (tr evad) = V ->
    (MinDistance T <= l intr evad T)%R ->
    (l intr evad T <= MaxDistance T)%R ->
    (cos (beta intr evad T) <= cos MinBeta)%R.

Lemma tau_le_0_diverg :
 (tau (measure2state intr 0) (measure2state (tr evad) 0) 0 <= 0)%R ->
 (d intr evad <= RR (measure2state intr 0) (measure2state (tr evad) 0) T)%R.
Proof with trivial.
intro; rewrite <- d_distance; rewrite distance_sym; rewrite <- R_distance...
cut (0 <= T)%R...
intro;
 generalize
  (asymptotic_increase_tau (measure2state intr 0) (measure2state (tr evad) 0)
     0 0 T H H0); intro...
repeat rewrite Rplus_0_l in H1...
left; apply Rlt_le_trans with MinT...
apply MinT_is_pos...
apply (cond_1 T)...
Qed.

Lemma R_T_d_diff_0 :
 h (tr evad) = V ->
 (0 < l intr evad T)%R ->
 (d intr evad <= RR (measure2state intr 0) (measure2state (tr evad) 0) T)%R ->
 (cos (beta intr evad T + thetat intr 0) <= cos (beta intr evad T))%R.
Proof with trivial.
intros hyp_evad H...
cut (0 <= d intr evad)%R...
cut (0 <= RR (measure2state intr 0) (measure2state (tr evad) 0) T)%R...
intros...
generalize
 (Rsqr_incr_1 _ (RR (measure2state intr 0) (measure2state (tr evad) 0) T) H2
    H1 H0); intro...
rewrite R_T in H3...
rewrite (d_l_beta intr evad T) in H3...
unfold ve in H3...
rewrite hyp_evad in H3...
rewrite Rsqr_minus in H3...
repeat rewrite Rsqr_mult in H3...
rewrite cos2 in H3...
generalize
 (Rplus_le_compat_l (- Rsqr (l intr evad T) - Rsqr V * Rsqr T)
    (Rsqr V * Rsqr T + Rsqr (l intr evad T) -
     2 * V * T * l intr evad T * cos (beta intr evad T))
    (Rsqr (l intr evad T) *
     (1 - Rsqr (sin (beta intr evad T + thetat intr 0))) + 
     Rsqr V * Rsqr T -
     2 * (l intr evad T * cos (beta intr evad T + thetat intr 0)) * (V * T) +
     Rsqr (l intr evad T) * Rsqr (sin (beta intr evad T + thetat intr 0))) H3)...
replace
 (- Rsqr (l intr evad T) - Rsqr V * Rsqr T +
  (Rsqr V * Rsqr T + Rsqr (l intr evad T) -
   2 * V * T * l intr evad T * cos (beta intr evad T)))%R with
 (2 * V * T * l intr evad T * - cos (beta intr evad T))%R...
replace
 (- Rsqr (l intr evad T) - Rsqr V * Rsqr T +
  (Rsqr (l intr evad T) * (1 - Rsqr (sin (beta intr evad T + thetat intr 0))) +
   Rsqr V * Rsqr T -
   2 * (l intr evad T * cos (beta intr evad T + thetat intr 0)) * (V * T) +
   Rsqr (l intr evad T) * Rsqr (sin (beta intr evad T + thetat intr 0))))%R
 with
 (2 * V * T * l intr evad T * - cos (beta intr evad T + thetat intr 0))%R...
intro...
rewrite <- (Ropp_involutive (cos (beta intr evad T)))...
rewrite <- (Ropp_involutive (cos (beta intr evad T + thetat intr 0)))...
apply Ropp_ge_le_contravar...
apply Rle_ge...
apply Rmult_le_reg_l with (2 * V * T * l intr evad T)%R...
repeat apply Rmult_lt_0_compat...
prove_sup0...
apply TypeSpeed_pos...
apply Rlt_le_trans with MinT; [ apply MinT_is_pos | apply (cond_1 T) ]...
unfold Rminus in |- *...
rewrite Rmult_plus_distr_l...
rewrite Rmult_1_r...
ring...
unfold Rminus in |- *...
ring...
(*Rewrite hyp_evad.*)
apply RR_pos...
unfold d in |- *; unfold Die in |- *; apply sqrt_positivity...
apply Rplus_le_le_0_compat; apply Rle_0_sqr...
Qed.

Lemma R_T_d_diff_1 :
 h (tr evad) = V ->
 (cos (beta intr evad T + thetat intr 0) <= cos (beta intr evad T))%R ->
 (d intr evad <= RR (measure2state intr 0) (measure2state (tr evad) 0) T)%R.
Proof with trivial.
intros...
apply Rsqr_incr_0...
rewrite R_T...
rewrite (d_l_beta intr evad T)...
unfold ve in |- *...
rewrite H...
rewrite Rsqr_minus...
repeat rewrite Rsqr_mult...
rewrite cos2...
replace
 (Rsqr (l intr evad T) * (1 - Rsqr (sin (beta intr evad T + thetat intr 0))) +
  Rsqr V * Rsqr T -
  2 * (l intr evad T * cos (beta intr evad T + thetat intr 0)) * (V * T) +
  Rsqr (l intr evad T) * Rsqr (sin (beta intr evad T + thetat intr 0)))%R
 with
 (Rsqr V * Rsqr T + Rsqr (l intr evad T) -
  2 * (l intr evad T * cos (beta intr evad T + thetat intr 0)) * (V * T))%R...
unfold Rminus in |- *...
apply Rplus_le_compat_l...
apply Ropp_ge_le_contravar...
apply Rle_ge...
repeat rewrite Rmult_assoc...
apply Rmult_le_compat_l...
left; prove_sup0...
rewrite <- (Rmult_comm (V * T))...
rewrite (Rmult_comm (l intr evad T))...
repeat rewrite Rmult_assoc...
apply Rmult_le_compat_l...
left; apply TypeSpeed_pos...
apply Rmult_le_compat_l...
left; apply Rlt_le_trans with MinT; [ apply MinT_is_pos | apply (cond_1 T) ]...
rewrite <- (Rmult_comm (l intr evad T))...
apply Rmult_le_compat_l...
apply l_is_pos...
unfold Rminus in |- *...
rewrite Rmult_plus_distr_l...
ring...
(*Rewrite H.*)
unfold d in |- *; unfold Die in |- *; apply sqrt_positivity;
 apply Rplus_le_le_0_compat; apply Rle_0_sqr...
apply RR_pos...
Qed.

Lemma cos_no_conflict :
 h intr = V ->
 h (tr evad) = V ->
 Alpha (beta intr evad T) = false ->
 (MinDistance T <= l intr evad T)%R ->
 (l intr evad T <= MaxDistance T)%R ->
 (cos (beta intr evad T + thetat intr 0) <= cos (beta intr evad T))%R ->
 Omega (thetat intr 0 + beta intr evad T) = false ->
 conflict intr evad T = false.
Proof with trivial.
intros hyp_intr hyp_evad; intros...
unfold conflict in |- *...
cut
 (l intr evad T * cos (beta intr evad T) <
  (Rsqr (ve evad * T) + Rsqr (l intr evad T) - Rsqr AlertRange) /
  (2 * ve evad * T))%R...
cut
 ((thetat intr 0 + beta intr evad T < PI / 2)%R \/
  (PI / 2 <= thetat intr 0 + beta intr evad T)%R /\
  (3 * (PI / 2) < thetat intr 0 + beta intr evad T)%R)...
intros...
case (Rle_dec (Die intr evad T T) ConflictRange); intro...
unfold Die in r...
generalize (isometric_evader intr evad T T)...
unfold Rsqr_evader_distance in |- *...
unfold xe, ye in |- *...
intro...
rewrite H6 in r...
cut (0 <= T)%R...
cut (rho_vi intr * T <= PI / 2)%R...
intros...
generalize (ypt_PI2 intr evad T T H8 H7); intro...
generalize
 (xpt_PI intr evad T T H8
    (Rle_trans (rho_vi intr * T) (PI / 2) PI H7
       (Rlt_le (PI / 2) PI PI2_Rlt_PI))); intro...
elim H4; intros...
rewrite Rplus_comm in H11...
cut (MinBeta <= beta intr evad T + thetat intr 0)%R...
intro...
elim H9; intros...
generalize
 (Math_prop_no_conflict_1 (beta intr evad T + thetat intr 0) 
    (l intr evad T) (xp intr evad T T) (yp intr evad T T) T H0 H1 H12
    (Rlt_le (beta intr evad T + thetat intr 0) (PI / 2) H11))...
unfold r_V, rho_V in |- *...
unfold r_vi, rho_vi in H13...
unfold r_vi, rho_vi in H10...
unfold vi in H10...
rewrite hyp_intr in H10...
unfold vi in H13...
rewrite hyp_intr in H13...
intro...
generalize (H15 H13 H10)...
intro...
cut (0 <= sqrt (Rsqr (xp intr evad T T) + Rsqr (yp intr evad T T)))%R...
cut (0 <= ConflictRange)%R...
intros...
generalize
 (Rsqr_incr_1 (sqrt (Rsqr (xp intr evad T T) + Rsqr (yp intr evad T T)))
    ConflictRange r H18 H17); intro...
rewrite Rsqr_sqrt in H19...
elim
 (Rlt_irrefl (Rsqr ConflictRange)
    (Rlt_le_trans (Rsqr ConflictRange)
       (Rsqr (xp intr evad T T) + Rsqr (yp intr evad T T))
       (Rsqr ConflictRange) H16 H19))...
apply Rplus_le_le_0_compat; apply Rle_0_sqr...
unfold ConflictRange in |- *; left; prove_sup...
apply sqrt_positivity; apply Rplus_le_le_0_compat; apply Rle_0_sqr...
apply cos_decr_0...
generalize (beta_def intr evad T); intro...
decompose [and] H12...
left; apply Rlt_trans with (PI / 2)%R...
apply PI2_Rlt_PI...
left; apply MinBeta_pos...
unfold MinBeta in |- *...
left; apply Rlt_trans with 1%R...
unfold Rdiv in |- *...
apply Rmult_lt_reg_l with 1000%R...
prove_sup...
rewrite Rmult_1_r; rewrite (Rmult_comm 1000); rewrite Rmult_assoc...
rewrite <- Rinv_l_sym; [ prove_sup | discrR ]...
apply Rlt_trans with (PI / 2)%R...
apply Rlt_1_PI2...
apply PI2_Rlt_PI...
apply Rle_trans with (cos (beta intr evad T))...
apply cos_beta_NOT_Alpha...
elim H11; intros...
rewrite (Rplus_comm (thetat intr 0)) in H13...
cut (beta intr evad T + thetat intr 0 <= 2 * PI - MinBeta)%R...
intro...
generalize
 (Math_prop_no_conflict_2 (beta intr evad T + thetat intr 0) 
    (l intr evad T) (xp intr evad T T) (yp intr evad T T) T H0 H1
    (Rlt_le (3 * (PI / 2)) (beta intr evad T + thetat intr 0) H13) H14);
 intro...
unfold r_V, rho_V in H15...
unfold r_vi, rho_vi in H10...
elim H9; intros...
unfold r_vi, rho_vi in H17...
unfold vi in H17...
rewrite hyp_intr in H17...
unfold vi in H10...
rewrite hyp_intr in H10...
generalize (H15 H17 H10); intro...
cut (0 <= sqrt (Rsqr (xp intr evad T T) + Rsqr (yp intr evad T T)))%R...
cut (0 <= ConflictRange)%R...
intros...
generalize
 (Rsqr_incr_1 (sqrt (Rsqr (xp intr evad T T) + Rsqr (yp intr evad T T)))
    ConflictRange r H20 H19); intro...
rewrite Rsqr_sqrt in H21...
elim
 (Rlt_irrefl (Rsqr ConflictRange)
    (Rlt_le_trans (Rsqr ConflictRange)
       (Rsqr (xp intr evad T T) + Rsqr (yp intr evad T T))
       (Rsqr ConflictRange) H18 H21))...
apply Rplus_le_le_0_compat; apply Rle_0_sqr...
unfold ConflictRange in |- *; left; prove_sup...
apply sqrt_positivity; apply Rplus_le_le_0_compat; apply Rle_0_sqr...
apply cos_incr_0...
left; apply Rlt_trans with (3 * (PI / 2))%R...
pattern PI at 1 in |- *; rewrite <- (Rplus_0_r PI)...
replace (3 * (PI / 2))%R with (PI + PI / 2)%R...
apply Rplus_lt_compat_l...
apply PI2_RGT_0...
pattern PI at 1 in |- *; rewrite double_var; ring...
generalize (beta_def intr evad T); intro...
decompose [and] H14...
left...
left...
apply Rplus_lt_reg_r with (MinBeta - PI)%R...
replace (MinBeta - PI + PI)%R with MinBeta...
replace (MinBeta - PI + (2 * PI - MinBeta))%R with PI...
unfold MinBeta in |- *...
apply Rlt_trans with 1%R...
unfold Rdiv in |- *...
apply Rmult_lt_reg_l with 1000%R...
prove_sup...
rewrite (Rmult_comm 1000); rewrite Rmult_assoc; rewrite <- Rinv_l_sym;
 [ repeat rewrite Rmult_1_r; prove_sup | discrR ]...
apply Rlt_trans with (PI / 2)%R...
apply Rlt_1_PI2...
apply PI2_Rlt_PI...
ring...
ring...
unfold Rminus in |- *...
pattern (2 * PI)%R at 2 in |- *; rewrite <- (Rplus_0_r (2 * PI))...
apply Rplus_le_compat_l...
left; rewrite <- Ropp_0...
apply Ropp_lt_gt_contravar...
apply MinBeta_pos...
unfold Rminus in |- *...
rewrite (Rplus_comm (2 * PI))...
generalize (cos_period (- MinBeta) 1)...
unfold INR in |- *...
rewrite Rmult_1_r...
intro...
rewrite H14...
rewrite cos_neg...
apply Rle_trans with (cos (beta intr evad T))...
apply cos_beta_NOT_Alpha...
left; replace (rho_vi intr) with rho_V...
apply rho_t_PI2...
unfold rho_vi, rho_V in |- *...
unfold vi in |- *; rewrite hyp_intr...
left; apply Rlt_le_trans with MinT...
apply MinT_is_pos...
apply (cond_1 T)...
cut (Omega (thetat intr 0 + beta intr evad T) = false)...
unfold Omega in |- *...
case (Rle_dec (PI / 2) (thetat intr 0 + beta intr evad T)); intro...
case (Rle_dec (thetat intr 0 + beta intr evad T) (3 * (PI / 2))); intros...
elim diff_true_false...
right...
split...
auto with real...
intro...
left; auto with real...
cut (Alpha (beta intr evad T) = false)...
unfold Alpha in |- *...
case
 (Rle_dec
    ((Rsqr (ve evad * T) + Rsqr (l intr evad T) - Rsqr AlertRange) /
     (2 * ve evad * T)) (l intr evad T * cos (beta intr evad T))); 
 intros...
elim diff_true_false...
auto with real...
Qed.

(**************************************************************)
(*************************** THEOREME *************************)
(**************************************************************)

Theorem ails_no_conflict_tau_le0 :
 h intr = V ->
 h (tr evad) = V ->
 (MinDistance T <= l intr evad T)%R ->
 (l intr evad T <= MaxDistance T)%R ->
 (AlertRange < d intr evad)%R ->
 Omega (thetat intr 0 + beta intr evad T) = false ->
 (tau (measure2state intr 0) (measure2state (tr evad) 0) 0 <= 0)%R ->
 conflict intr evad T = false.
Proof with trivial.
intros; apply cos_no_conflict...
apply (Alpha_d_AlertRange_3 H3)...
apply R_T_d_diff_0...
apply Rlt_le_trans with (MinDistance T)...
apply MinDistance_pos...
apply tau_le_0_diverg...
Qed.

End alpha_no_conflict.