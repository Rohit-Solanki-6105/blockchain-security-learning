<pre style="color: red;">
INFO:Detectors:
Detector: reentrancy-eth
Reentrancy in VulnerableBank.withdraw(uint256) (contracts/Reentrancy/VulnerableBank.sol#13-22):
        External calls:
        - (success,None) = msg.sender.call{value: _amount}() (contracts/Reentrancy/VulnerableBank.sol#17)
        State variables written after the call(s):
        - balances[msg.sender] -= _amount (contracts/Reentrancy/VulnerableBank.sol#21)
        VulnerableBank.balances (contracts/Reentrancy/VulnerableBank.sol#5) can be used in cross function reentrancies:
        - VulnerableBank.balances (contracts/Reentrancy/VulnerableBank.sol#5)
        - VulnerableBank.deposit() (contracts/Reentrancy/VulnerableBank.sol#8-10)
        - VulnerableBank.withdraw(uint256) (contracts/Reentrancy/VulnerableBank.sol#13-22)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-1
</pre>

## Automated Static Analysis Report (Slither)

As part of the security auditing process, this lab was analyzed using [Slither](https://github.com/crytic/slither), a Python-based static analyzer for Solidity. 

The analysis scanned the `VulnerableBank`, `ReentrancyAttacker`, and `SecureBank` contracts and successfully identified the core vulnerability.

### 🔴 High Severity Findings

**1. Reentrancy Vulnerability**
* **Target:** `VulnerableBank.withdraw(uint256)`
* **Lines:** `contracts/Reentrancy/VulnerableBank.sol#13-22`
* **Description:** Slither accurately flagged a critical Reentrancy vulnerability. The contract executes an external low-level call `(msg.sender.call{value: _amount}())` *before* it updates the internal state ledger `(balances[msg.sender] -= _amount)`. 
* **Security Insight:** An attacker can exploit this by using a malicious fallback function to recursively call `withdraw()` before their balance is ever decremented, draining the vault. Note that `SecureBank.sol` did **not** trigger this warning, proving that applying the **Checks-Effects-Interactions (CEI)** pattern and a Mutex lock completely mitigates the attack vector.

### 🟢 Low Severity & Informational Findings

**1. Low-Level Calls**
* **Targets:** `VulnerableBank.withdraw()` and `SecureBank.withdraw()`
* **Description:** Slither flags all instances of raw `.call{value: amount}()` usage. 
* **Resolution:** While flagged in both contracts, the implementation in `SecureBank` is secure because it mutates state before the call and uses a `noReentrant` modifier.

**2. State Variable Could Be Immutable (`immutable-states`)**
* **Target:** `ReentrancyAttacker.bank`
* **Description:** The `bank` interface variable is assigned once in the constructor and never changed.
* **Resolution:** Declaring it as `immutable` (e.g., `IVulnerableBank public immutable bank;`) would save deployment and execution gas. 

**3. Unlocked Pragma Version (`solc-version`)**
* **Targets:** All Contracts (`^0.8.20`)
* **Description:** The contracts use a floating pragma version (`^0.8.20`).
* **Resolution:** For production deployments, it is an industry best practice to lock the compiler version (e.g., `pragma solidity 0.8.20;`).

**4. Naming Conventions (`naming-convention`)**
* **Targets:** `VulnerableBank` and `SecureBank` parameters
* **Description:** Slither noted that the parameter `_amount` includes a leading underscore.
* **Resolution:** Standard Solidity naming conventions prefer `amount` over `_amount` for function parameters.

---
*Generated via: `slither contracts/Reentrancy/`*

----

Multiple frameworks detected: solc, Solc-json. Using solc (highest priority). Use --compile-force-framework to override.
'solc --version' running
'solc contracts/Reentrancy/VulnerableBank.sol --combined-json abi,ast,bin,bin-runtime,srcmap,srcmap-runtime,userdoc,devdoc,hashes --allow-paths .,/home/rohitsolanki/Desktop/projects/pi2_128_sc/contracts/Reentrancy' running
Multiple frameworks detected: solc, Solc-json. Using solc (highest priority). Use --compile-force-framework to override.
'solc --version' running
'solc contracts/Reentrancy/ReentrancyAttacker.sol --combined-json abi,ast,bin,bin-runtime,srcmap,srcmap-runtime,userdoc,devdoc,hashes --allow-paths .,/home/rohitsolanki/Desktop/projects/pi2_128_sc/contracts/Reentrancy' running
Multiple frameworks detected: solc, Solc-json. Using solc (highest priority). Use --compile-force-framework to override.
'solc --version' running
'solc contracts/Reentrancy/SecureBank.sol --combined-json abi,ast,bin,bin-runtime,srcmap,srcmap-runtime,userdoc,devdoc,hashes --allow-paths .,/home/rohitsolanki/Desktop/projects/pi2_128_sc/contracts/Reentrancy' running
**THIS CHECKLIST IS NOT COMPLETE**. Use `--show-ignored-findings` to show all the results.
Summary
 - [reentrancy-eth](#reentrancy-eth) (1 results) (High)
 - [solc-version](#solc-version) (3 results) (Informational)
 - [low-level-calls](#low-level-calls) (2 results) (Informational)
 - [naming-convention](#naming-convention) (2 results) (Informational)
 - [immutable-states](#immutable-states) (1 results) (Optimization)
## reentrancy-eth
Impact: High
Confidence: Medium
 - [ ] ID-0
Reentrancy in [VulnerableBank.withdraw(uint256)](contracts/Reentrancy/VulnerableBank.sol#L13-L22):
	External calls:
	- [(success,None) = msg.sender.call{value: _amount}()](contracts/Reentrancy/VulnerableBank.sol#L17)
	State variables written after the call(s):
	- [balances[msg.sender] -= _amount](contracts/Reentrancy/VulnerableBank.sol#L21)
	[VulnerableBank.balances](contracts/Reentrancy/VulnerableBank.sol#L5) can be used in cross function reentrancies:
	- [VulnerableBank.balances](contracts/Reentrancy/VulnerableBank.sol#L5)
	- [VulnerableBank.deposit()](contracts/Reentrancy/VulnerableBank.sol#L8-L10)
	- [VulnerableBank.withdraw(uint256)](contracts/Reentrancy/VulnerableBank.sol#L13-L22)

contracts/Reentrancy/VulnerableBank.sol#L13-L22


## solc-version
Impact: Informational
Confidence: High
 - [ ] ID-1
Version constraint ^0.8.20 contains known severe issues (https://solidity.readthedocs.io/en/latest/bugs.html)
	- VerbatimInvalidDeduplication
	- FullInlinerNonExpressionSplitArgumentEvaluationOrder
	- MissingSideEffectsOnSelectorAccess.
It is used by:
	- [^0.8.20](contracts/Reentrancy/VulnerableBank.sol#L2)

contracts/Reentrancy/VulnerableBank.sol#L2


 - [ ] ID-2
Version constraint ^0.8.20 contains known severe issues (https://solidity.readthedocs.io/en/latest/bugs.html)
	- VerbatimInvalidDeduplication
	- FullInlinerNonExpressionSplitArgumentEvaluationOrder
	- MissingSideEffectsOnSelectorAccess.
It is used by:
	- [^0.8.20](contracts/Reentrancy/ReentrancyAttacker.sol#L2)

contracts/Reentrancy/ReentrancyAttacker.sol#L2


 - [ ] ID-3
Version constraint ^0.8.20 contains known severe issues (https://solidity.readthedocs.io/en/latest/bugs.html)
	- VerbatimInvalidDeduplication
	- FullInlinerNonExpressionSplitArgumentEvaluationOrder
	- MissingSideEffectsOnSelectorAccess.
It is used by:
	- [^0.8.20](contracts/Reentrancy/SecureBank.sol#L2)

contracts/Reentrancy/SecureBank.sol#L2


## low-level-calls
Impact: Informational
Confidence: High
 - [ ] ID-4
Low level call in [VulnerableBank.withdraw(uint256)](contracts/Reentrancy/VulnerableBank.sol#L13-L22):
	- [(success,None) = msg.sender.call{value: _amount}()](contracts/Reentrancy/VulnerableBank.sol#L17)

contracts/Reentrancy/VulnerableBank.sol#L13-L22


 - [ ] ID-5
Low level call in [SecureBank.withdraw(uint256)](contracts/Reentrancy/SecureBank.sol#L21-L30):
	- [(success,None) = msg.sender.call{value: _amount}()](contracts/Reentrancy/SecureBank.sol#L28)

contracts/Reentrancy/SecureBank.sol#L21-L30


## naming-convention
Impact: Informational
Confidence: High
 - [ ] ID-6
Parameter [VulnerableBank.withdraw(uint256)._amount](contracts/Reentrancy/VulnerableBank.sol#L13) is not in mixedCase

contracts/Reentrancy/VulnerableBank.sol#L13


 - [ ] ID-7
Parameter [SecureBank.withdraw(uint256)._amount](contracts/Reentrancy/SecureBank.sol#L21) is not in mixedCase

contracts/Reentrancy/SecureBank.sol#L21


## immutable-states
Impact: Optimization
Confidence: High
 - [ ] ID-8
[ReentrancyAttacker.bank](contracts/Reentrancy/ReentrancyAttacker.sol#L10) should be immutable 

contracts/Reentrancy/ReentrancyAttacker.sol#L10


