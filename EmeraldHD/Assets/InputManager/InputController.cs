// GENERATED AUTOMATICALLY FROM 'Assets/InputManager/InputController.inputactions'

using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.Utilities;

public class @InputController : IInputActionCollection, IDisposable
{
    public InputActionAsset asset { get; }
    public @InputController()
    {
        asset = InputActionAsset.FromJson(@"{
    ""name"": ""InputController"",
    ""maps"": [
        {
            ""name"": ""UI"",
            ""id"": ""7e2ed109-e820-41cf-a13e-e38467293bb0"",
            ""actions"": [
                {
                    ""name"": ""Inventory"",
                    ""type"": ""Button"",
                    ""id"": ""790212eb-81c4-44f3-977d-991dc2c7d438"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Character"",
                    ""type"": ""Button"",
                    ""id"": ""7a4da4cf-51da-4d71-9167-72c512a4f4bc"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Skills"",
                    ""type"": ""Button"",
                    ""id"": ""01f7add7-1e48-47cd-9849-5c80cf3d1188"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Options"",
                    ""type"": ""Button"",
                    ""id"": ""9d67b844-cd3a-4108-aebb-523c1b35d90c"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Guild"",
                    ""type"": ""Button"",
                    ""id"": ""7541bb9d-891e-4f86-8146-5946bb777895"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""MiniMap"",
                    ""type"": ""Button"",
                    ""id"": ""583c0773-5ae8-438d-8845-003fcbbeb09a"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Return"",
                    ""type"": ""Button"",
                    ""id"": ""cfa6a2bd-6294-4909-8a78-7a8c19e37334"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Party"",
                    ""type"": ""Button"",
                    ""id"": ""eafffaf8-d6c0-403a-b0a8-815d19edbc68"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Escape"",
                    ""type"": ""Button"",
                    ""id"": ""dd9dcb36-ec44-410f-a89f-d5d5793d5eb8"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                }
            ],
            ""bindings"": [
                {
                    ""name"": """",
                    ""id"": ""23449613-34d6-44ca-9c67-940f5a3514a3"",
                    ""path"": ""<Keyboard>/i"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Inventory"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""e50fc71a-1fc2-4f47-a859-8ff42ef62eb5"",
                    ""path"": ""<Keyboard>/f9"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Inventory"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""27091022-5cd9-4d94-ba88-54325281d1e8"",
                    ""path"": ""<Keyboard>/f10"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Character"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""12ad3251-931b-4797-a339-60155f8fb845"",
                    ""path"": ""<Keyboard>/c"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Character"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""92ace2bc-f0d0-4c14-9538-38e2488f8779"",
                    ""path"": ""<Keyboard>/f11"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Skills"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""0cacaeea-3eaf-4274-9c2d-f1d43a7b76be"",
                    ""path"": ""<Keyboard>/k"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Skills"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""d4312e58-f729-4529-a75f-df7c411aa435"",
                    ""path"": ""<Keyboard>/f12"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Options"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""d91bd967-b92a-4833-a928-feeaf3d5264d"",
                    ""path"": ""<Keyboard>/o"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Options"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""4a051fea-5338-48cf-b293-c26c1ede645b"",
                    ""path"": ""<Keyboard>/g"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Guild"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""7e41aba1-f75a-4845-b27c-c159cf43a908"",
                    ""path"": ""<Keyboard>/v"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""MiniMap"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""b9bca8b4-1c23-452a-aad9-f159c19598ce"",
                    ""path"": """",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Return"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""9fec0cf3-ec9d-4429-b77f-1c0cbd033bef"",
                    ""path"": ""<Keyboard>/p"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Party"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""512d2dac-3ddf-49ea-8085-9c0cbe316f35"",
                    ""path"": ""<Keyboard>/escape"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Escape"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                }
            ]
        },
        {
            ""name"": ""QuickSlots"",
            ""id"": ""c256b9c9-2897-4d18-b345-288c53289a45"",
            ""actions"": [
                {
                    ""name"": ""QuickSlot_F1"",
                    ""type"": ""Button"",
                    ""id"": ""8176083a-e138-46ac-b7ea-bcae8ae24b88"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuickSlot_F2"",
                    ""type"": ""Button"",
                    ""id"": ""90d00d5e-3e29-4896-b548-b03277fbff41"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuickSlot_F3"",
                    ""type"": ""Button"",
                    ""id"": ""8866f3dd-66ad-49bb-8c20-3c578177cac4"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuickSlot_F4"",
                    ""type"": ""Button"",
                    ""id"": ""a749e91d-ce60-48b1-be27-93ad706232a4"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuickSlot_F5"",
                    ""type"": ""Button"",
                    ""id"": ""98d45791-8a1b-4d0f-b0a5-092c613c7aef"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuickSlot_F6"",
                    ""type"": ""Button"",
                    ""id"": ""f816f340-6caa-42b7-b391-f0fcde6b0d76"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuickSlot_S"",
                    ""type"": ""Button"",
                    ""id"": ""8afc7397-b065-4e75-b8d4-6e93ea00f06f"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuickSlot_D"",
                    ""type"": ""Button"",
                    ""id"": ""ca8ca21f-f091-4dea-8304-94c8ab759e2a"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuickSlot_Q"",
                    ""type"": ""Button"",
                    ""id"": ""b9e78c50-139f-4a67-b4f2-036887f5203c"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuickSlot_Y"",
                    ""type"": ""Button"",
                    ""id"": ""aed4d2d5-274a-4653-b350-c04c71569b02"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuickSlot_B"",
                    ""type"": ""Button"",
                    ""id"": ""5dc243c8-ff69-4b2d-8aac-af4438d6f596"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuickSlot_H"",
                    ""type"": ""Button"",
                    ""id"": ""02f6d2da-fb33-4386-a85b-44fede5eb1af"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuickSlot_1"",
                    ""type"": ""Button"",
                    ""id"": ""acc15545-651f-4078-9dc4-607a5a82488d"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuickSlot_2"",
                    ""type"": ""Button"",
                    ""id"": ""d603ec90-c029-47d0-8479-2f373f1afacf"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuickSlot_3"",
                    ""type"": ""Button"",
                    ""id"": ""8b76c2dd-1885-48cd-890f-c3e7e88986f3"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuickSlot_4"",
                    ""type"": ""Button"",
                    ""id"": ""16661793-d0c7-4dfd-89cc-0f82ed4352d3"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuickSlot_5"",
                    ""type"": ""Button"",
                    ""id"": ""ab6a0f18-2f47-4859-88bf-5c4476ed6c20"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuickSlot_6"",
                    ""type"": ""Button"",
                    ""id"": ""1a4bf615-ed3c-459f-83f8-dccca64f435e"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuickSlot_7"",
                    ""type"": ""Button"",
                    ""id"": ""0be6ff9d-8d7b-4e20-bbfd-25bf91d69358"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuickSlot_8"",
                    ""type"": ""Button"",
                    ""id"": ""a0d9409f-0ba0-40aa-995b-33d13a50a494"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuickSlot_9"",
                    ""type"": ""Button"",
                    ""id"": ""a9f36315-c89e-4959-ac47-5b80d79681b8"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuickSlot_0"",
                    ""type"": ""Button"",
                    ""id"": ""57d430ef-5084-4623-a094-db718c2261aa"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuickSlot_minus"",
                    ""type"": ""Button"",
                    ""id"": ""6959b053-c336-4fcc-9eed-21580b7ab501"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""QuickSlot_equals"",
                    ""type"": ""Button"",
                    ""id"": ""4d1a25ee-3907-4f60-aaec-0a693bfd905b"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                }
            ],
            ""bindings"": [
                {
                    ""name"": """",
                    ""id"": ""398520f2-6f82-419f-904a-133b05fa26ed"",
                    ""path"": ""<Keyboard>/f1"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_F1"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""027f271d-e9ed-4778-84d2-b88ce84af58f"",
                    ""path"": ""<Keyboard>/f2"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_F2"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""70345e21-2386-49d7-878b-1cc13373ed09"",
                    ""path"": ""<Keyboard>/f3"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_F3"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""b2ec8417-5447-4c97-a460-de451e7361e7"",
                    ""path"": ""<Keyboard>/f4"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_F4"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""b151d438-9542-4eb0-b149-75e048d67a96"",
                    ""path"": ""<Keyboard>/f5"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_F5"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""5a6557a7-0f5e-4c25-bd31-39bcbee15b51"",
                    ""path"": ""<Keyboard>/f6"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_F6"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""bc18929d-9ff5-43dc-ae43-f60d4df0a298"",
                    ""path"": ""<Keyboard>/s"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_S"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""d2575c31-b4ce-44f0-850a-2c0556dcb43c"",
                    ""path"": ""<Keyboard>/d"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_D"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""bb6609dc-ee92-4280-b419-818a2f85180d"",
                    ""path"": ""<Keyboard>/q"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_Q"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""32c3f33a-052a-44d4-a4cc-f04c18e035bf"",
                    ""path"": ""<Keyboard>/y"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_Y"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""69915672-36b3-4a66-a921-d6019beffcb7"",
                    ""path"": ""<Keyboard>/b"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_B"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""0fa47667-0bc4-4a3d-be39-6a947a23f421"",
                    ""path"": ""<Keyboard>/h"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_H"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""f3bffc0d-e114-4d96-a3e5-d93079c732a6"",
                    ""path"": ""<Keyboard>/1"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_1"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""32c8cded-112b-4aa3-bc71-a16c36060b04"",
                    ""path"": ""<Keyboard>/2"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_2"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""4800d16e-f22b-489b-8852-a303b4eeaf77"",
                    ""path"": ""<Keyboard>/3"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_3"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""ef1b1512-43a5-4f72-bbf9-7eeeb2a9252c"",
                    ""path"": ""<Keyboard>/4"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_4"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""239b7d66-cd10-49a5-be54-cf33ab467092"",
                    ""path"": ""<Keyboard>/5"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_5"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""6c70f737-efec-486c-b76c-9eecc1a04d33"",
                    ""path"": ""<Keyboard>/6"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_6"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""3d85b378-cc28-4bd9-8979-1f06ea19a535"",
                    ""path"": ""<Keyboard>/7"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_7"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""2152cecf-063b-4985-935f-315bc6a057b8"",
                    ""path"": ""<Keyboard>/8"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_8"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""185ae23c-527e-4088-aa75-006d2bb4db95"",
                    ""path"": ""<Keyboard>/9"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_9"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""603f896e-3c97-4732-88a6-cbee3b0c180b"",
                    ""path"": ""<Keyboard>/minus"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_minus"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""428477c1-ff70-4e00-b6ed-52e625f313f0"",
                    ""path"": ""<Keyboard>/equals"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_equals"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""76d72cad-1171-4fd0-bf32-ad5dc26915c9"",
                    ""path"": ""<Keyboard>/0"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""QuickSlot_0"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                }
            ]
        },
        {
            ""name"": ""Chat"",
            ""id"": ""c091414f-1e52-4799-9d75-53575cb78e55"",
            ""actions"": [
                {
                    ""name"": ""New action"",
                    ""type"": ""Button"",
                    ""id"": ""256be55c-ef48-44d3-92b5-ee181a084371"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                }
            ],
            ""bindings"": [
                {
                    ""name"": """",
                    ""id"": ""930ffe6e-64ac-446e-aaf3-a038ac4cf12b"",
                    ""path"": ""<Keyboard>/enter"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""New action"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                }
            ]
        }
    ],
    ""controlSchemes"": []
}");
        // UI
        m_UI = asset.FindActionMap("UI", throwIfNotFound: true);
        m_UI_Inventory = m_UI.FindAction("Inventory", throwIfNotFound: true);
        m_UI_Character = m_UI.FindAction("Character", throwIfNotFound: true);
        m_UI_Skills = m_UI.FindAction("Skills", throwIfNotFound: true);
        m_UI_Options = m_UI.FindAction("Options", throwIfNotFound: true);
        m_UI_Guild = m_UI.FindAction("Guild", throwIfNotFound: true);
        m_UI_MiniMap = m_UI.FindAction("MiniMap", throwIfNotFound: true);
        m_UI_Return = m_UI.FindAction("Return", throwIfNotFound: true);
        m_UI_Party = m_UI.FindAction("Party", throwIfNotFound: true);
        m_UI_Escape = m_UI.FindAction("Escape", throwIfNotFound: true);
        // QuickSlots
        m_QuickSlots = asset.FindActionMap("QuickSlots", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_F1 = m_QuickSlots.FindAction("QuickSlot_F1", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_F2 = m_QuickSlots.FindAction("QuickSlot_F2", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_F3 = m_QuickSlots.FindAction("QuickSlot_F3", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_F4 = m_QuickSlots.FindAction("QuickSlot_F4", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_F5 = m_QuickSlots.FindAction("QuickSlot_F5", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_F6 = m_QuickSlots.FindAction("QuickSlot_F6", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_S = m_QuickSlots.FindAction("QuickSlot_S", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_D = m_QuickSlots.FindAction("QuickSlot_D", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_Q = m_QuickSlots.FindAction("QuickSlot_Q", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_Y = m_QuickSlots.FindAction("QuickSlot_Y", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_B = m_QuickSlots.FindAction("QuickSlot_B", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_H = m_QuickSlots.FindAction("QuickSlot_H", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_1 = m_QuickSlots.FindAction("QuickSlot_1", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_2 = m_QuickSlots.FindAction("QuickSlot_2", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_3 = m_QuickSlots.FindAction("QuickSlot_3", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_4 = m_QuickSlots.FindAction("QuickSlot_4", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_5 = m_QuickSlots.FindAction("QuickSlot_5", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_6 = m_QuickSlots.FindAction("QuickSlot_6", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_7 = m_QuickSlots.FindAction("QuickSlot_7", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_8 = m_QuickSlots.FindAction("QuickSlot_8", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_9 = m_QuickSlots.FindAction("QuickSlot_9", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_0 = m_QuickSlots.FindAction("QuickSlot_0", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_minus = m_QuickSlots.FindAction("QuickSlot_minus", throwIfNotFound: true);
        m_QuickSlots_QuickSlot_equals = m_QuickSlots.FindAction("QuickSlot_equals", throwIfNotFound: true);
        // Chat
        m_Chat = asset.FindActionMap("Chat", throwIfNotFound: true);
        m_Chat_Newaction = m_Chat.FindAction("New action", throwIfNotFound: true);
    }

    public void Dispose()
    {
        UnityEngine.Object.Destroy(asset);
    }

    public InputBinding? bindingMask
    {
        get => asset.bindingMask;
        set => asset.bindingMask = value;
    }

    public ReadOnlyArray<InputDevice>? devices
    {
        get => asset.devices;
        set => asset.devices = value;
    }

    public ReadOnlyArray<InputControlScheme> controlSchemes => asset.controlSchemes;

    public bool Contains(InputAction action)
    {
        return asset.Contains(action);
    }

    public IEnumerator<InputAction> GetEnumerator()
    {
        return asset.GetEnumerator();
    }

    IEnumerator IEnumerable.GetEnumerator()
    {
        return GetEnumerator();
    }

    public void Enable()
    {
        asset.Enable();
    }

    public void Disable()
    {
        asset.Disable();
    }

    // UI
    private readonly InputActionMap m_UI;
    private IUIActions m_UIActionsCallbackInterface;
    private readonly InputAction m_UI_Inventory;
    private readonly InputAction m_UI_Character;
    private readonly InputAction m_UI_Skills;
    private readonly InputAction m_UI_Options;
    private readonly InputAction m_UI_Guild;
    private readonly InputAction m_UI_MiniMap;
    private readonly InputAction m_UI_Return;
    private readonly InputAction m_UI_Party;
    private readonly InputAction m_UI_Escape;
    public struct UIActions
    {
        private @InputController m_Wrapper;
        public UIActions(@InputController wrapper) { m_Wrapper = wrapper; }
        public InputAction @Inventory => m_Wrapper.m_UI_Inventory;
        public InputAction @Character => m_Wrapper.m_UI_Character;
        public InputAction @Skills => m_Wrapper.m_UI_Skills;
        public InputAction @Options => m_Wrapper.m_UI_Options;
        public InputAction @Guild => m_Wrapper.m_UI_Guild;
        public InputAction @MiniMap => m_Wrapper.m_UI_MiniMap;
        public InputAction @Return => m_Wrapper.m_UI_Return;
        public InputAction @Party => m_Wrapper.m_UI_Party;
        public InputAction @Escape => m_Wrapper.m_UI_Escape;
        public InputActionMap Get() { return m_Wrapper.m_UI; }
        public void Enable() { Get().Enable(); }
        public void Disable() { Get().Disable(); }
        public bool enabled => Get().enabled;
        public static implicit operator InputActionMap(UIActions set) { return set.Get(); }
        public void SetCallbacks(IUIActions instance)
        {
            if (m_Wrapper.m_UIActionsCallbackInterface != null)
            {
                @Inventory.started -= m_Wrapper.m_UIActionsCallbackInterface.OnInventory;
                @Inventory.performed -= m_Wrapper.m_UIActionsCallbackInterface.OnInventory;
                @Inventory.canceled -= m_Wrapper.m_UIActionsCallbackInterface.OnInventory;
                @Character.started -= m_Wrapper.m_UIActionsCallbackInterface.OnCharacter;
                @Character.performed -= m_Wrapper.m_UIActionsCallbackInterface.OnCharacter;
                @Character.canceled -= m_Wrapper.m_UIActionsCallbackInterface.OnCharacter;
                @Skills.started -= m_Wrapper.m_UIActionsCallbackInterface.OnSkills;
                @Skills.performed -= m_Wrapper.m_UIActionsCallbackInterface.OnSkills;
                @Skills.canceled -= m_Wrapper.m_UIActionsCallbackInterface.OnSkills;
                @Options.started -= m_Wrapper.m_UIActionsCallbackInterface.OnOptions;
                @Options.performed -= m_Wrapper.m_UIActionsCallbackInterface.OnOptions;
                @Options.canceled -= m_Wrapper.m_UIActionsCallbackInterface.OnOptions;
                @Guild.started -= m_Wrapper.m_UIActionsCallbackInterface.OnGuild;
                @Guild.performed -= m_Wrapper.m_UIActionsCallbackInterface.OnGuild;
                @Guild.canceled -= m_Wrapper.m_UIActionsCallbackInterface.OnGuild;
                @MiniMap.started -= m_Wrapper.m_UIActionsCallbackInterface.OnMiniMap;
                @MiniMap.performed -= m_Wrapper.m_UIActionsCallbackInterface.OnMiniMap;
                @MiniMap.canceled -= m_Wrapper.m_UIActionsCallbackInterface.OnMiniMap;
                @Return.started -= m_Wrapper.m_UIActionsCallbackInterface.OnReturn;
                @Return.performed -= m_Wrapper.m_UIActionsCallbackInterface.OnReturn;
                @Return.canceled -= m_Wrapper.m_UIActionsCallbackInterface.OnReturn;
                @Party.started -= m_Wrapper.m_UIActionsCallbackInterface.OnParty;
                @Party.performed -= m_Wrapper.m_UIActionsCallbackInterface.OnParty;
                @Party.canceled -= m_Wrapper.m_UIActionsCallbackInterface.OnParty;
                @Escape.started -= m_Wrapper.m_UIActionsCallbackInterface.OnEscape;
                @Escape.performed -= m_Wrapper.m_UIActionsCallbackInterface.OnEscape;
                @Escape.canceled -= m_Wrapper.m_UIActionsCallbackInterface.OnEscape;
            }
            m_Wrapper.m_UIActionsCallbackInterface = instance;
            if (instance != null)
            {
                @Inventory.started += instance.OnInventory;
                @Inventory.performed += instance.OnInventory;
                @Inventory.canceled += instance.OnInventory;
                @Character.started += instance.OnCharacter;
                @Character.performed += instance.OnCharacter;
                @Character.canceled += instance.OnCharacter;
                @Skills.started += instance.OnSkills;
                @Skills.performed += instance.OnSkills;
                @Skills.canceled += instance.OnSkills;
                @Options.started += instance.OnOptions;
                @Options.performed += instance.OnOptions;
                @Options.canceled += instance.OnOptions;
                @Guild.started += instance.OnGuild;
                @Guild.performed += instance.OnGuild;
                @Guild.canceled += instance.OnGuild;
                @MiniMap.started += instance.OnMiniMap;
                @MiniMap.performed += instance.OnMiniMap;
                @MiniMap.canceled += instance.OnMiniMap;
                @Return.started += instance.OnReturn;
                @Return.performed += instance.OnReturn;
                @Return.canceled += instance.OnReturn;
                @Party.started += instance.OnParty;
                @Party.performed += instance.OnParty;
                @Party.canceled += instance.OnParty;
                @Escape.started += instance.OnEscape;
                @Escape.performed += instance.OnEscape;
                @Escape.canceled += instance.OnEscape;
            }
        }
    }
    public UIActions @UI => new UIActions(this);

    // QuickSlots
    private readonly InputActionMap m_QuickSlots;
    private IQuickSlotsActions m_QuickSlotsActionsCallbackInterface;
    private readonly InputAction m_QuickSlots_QuickSlot_F1;
    private readonly InputAction m_QuickSlots_QuickSlot_F2;
    private readonly InputAction m_QuickSlots_QuickSlot_F3;
    private readonly InputAction m_QuickSlots_QuickSlot_F4;
    private readonly InputAction m_QuickSlots_QuickSlot_F5;
    private readonly InputAction m_QuickSlots_QuickSlot_F6;
    private readonly InputAction m_QuickSlots_QuickSlot_S;
    private readonly InputAction m_QuickSlots_QuickSlot_D;
    private readonly InputAction m_QuickSlots_QuickSlot_Q;
    private readonly InputAction m_QuickSlots_QuickSlot_Y;
    private readonly InputAction m_QuickSlots_QuickSlot_B;
    private readonly InputAction m_QuickSlots_QuickSlot_H;
    private readonly InputAction m_QuickSlots_QuickSlot_1;
    private readonly InputAction m_QuickSlots_QuickSlot_2;
    private readonly InputAction m_QuickSlots_QuickSlot_3;
    private readonly InputAction m_QuickSlots_QuickSlot_4;
    private readonly InputAction m_QuickSlots_QuickSlot_5;
    private readonly InputAction m_QuickSlots_QuickSlot_6;
    private readonly InputAction m_QuickSlots_QuickSlot_7;
    private readonly InputAction m_QuickSlots_QuickSlot_8;
    private readonly InputAction m_QuickSlots_QuickSlot_9;
    private readonly InputAction m_QuickSlots_QuickSlot_0;
    private readonly InputAction m_QuickSlots_QuickSlot_minus;
    private readonly InputAction m_QuickSlots_QuickSlot_equals;
    public struct QuickSlotsActions
    {
        private @InputController m_Wrapper;
        public QuickSlotsActions(@InputController wrapper) { m_Wrapper = wrapper; }
        public InputAction @QuickSlot_F1 => m_Wrapper.m_QuickSlots_QuickSlot_F1;
        public InputAction @QuickSlot_F2 => m_Wrapper.m_QuickSlots_QuickSlot_F2;
        public InputAction @QuickSlot_F3 => m_Wrapper.m_QuickSlots_QuickSlot_F3;
        public InputAction @QuickSlot_F4 => m_Wrapper.m_QuickSlots_QuickSlot_F4;
        public InputAction @QuickSlot_F5 => m_Wrapper.m_QuickSlots_QuickSlot_F5;
        public InputAction @QuickSlot_F6 => m_Wrapper.m_QuickSlots_QuickSlot_F6;
        public InputAction @QuickSlot_S => m_Wrapper.m_QuickSlots_QuickSlot_S;
        public InputAction @QuickSlot_D => m_Wrapper.m_QuickSlots_QuickSlot_D;
        public InputAction @QuickSlot_Q => m_Wrapper.m_QuickSlots_QuickSlot_Q;
        public InputAction @QuickSlot_Y => m_Wrapper.m_QuickSlots_QuickSlot_Y;
        public InputAction @QuickSlot_B => m_Wrapper.m_QuickSlots_QuickSlot_B;
        public InputAction @QuickSlot_H => m_Wrapper.m_QuickSlots_QuickSlot_H;
        public InputAction @QuickSlot_1 => m_Wrapper.m_QuickSlots_QuickSlot_1;
        public InputAction @QuickSlot_2 => m_Wrapper.m_QuickSlots_QuickSlot_2;
        public InputAction @QuickSlot_3 => m_Wrapper.m_QuickSlots_QuickSlot_3;
        public InputAction @QuickSlot_4 => m_Wrapper.m_QuickSlots_QuickSlot_4;
        public InputAction @QuickSlot_5 => m_Wrapper.m_QuickSlots_QuickSlot_5;
        public InputAction @QuickSlot_6 => m_Wrapper.m_QuickSlots_QuickSlot_6;
        public InputAction @QuickSlot_7 => m_Wrapper.m_QuickSlots_QuickSlot_7;
        public InputAction @QuickSlot_8 => m_Wrapper.m_QuickSlots_QuickSlot_8;
        public InputAction @QuickSlot_9 => m_Wrapper.m_QuickSlots_QuickSlot_9;
        public InputAction @QuickSlot_0 => m_Wrapper.m_QuickSlots_QuickSlot_0;
        public InputAction @QuickSlot_minus => m_Wrapper.m_QuickSlots_QuickSlot_minus;
        public InputAction @QuickSlot_equals => m_Wrapper.m_QuickSlots_QuickSlot_equals;
        public InputActionMap Get() { return m_Wrapper.m_QuickSlots; }
        public void Enable() { Get().Enable(); }
        public void Disable() { Get().Disable(); }
        public bool enabled => Get().enabled;
        public static implicit operator InputActionMap(QuickSlotsActions set) { return set.Get(); }
        public void SetCallbacks(IQuickSlotsActions instance)
        {
            if (m_Wrapper.m_QuickSlotsActionsCallbackInterface != null)
            {
                @QuickSlot_F1.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_F1;
                @QuickSlot_F1.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_F1;
                @QuickSlot_F1.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_F1;
                @QuickSlot_F2.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_F2;
                @QuickSlot_F2.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_F2;
                @QuickSlot_F2.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_F2;
                @QuickSlot_F3.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_F3;
                @QuickSlot_F3.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_F3;
                @QuickSlot_F3.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_F3;
                @QuickSlot_F4.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_F4;
                @QuickSlot_F4.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_F4;
                @QuickSlot_F4.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_F4;
                @QuickSlot_F5.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_F5;
                @QuickSlot_F5.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_F5;
                @QuickSlot_F5.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_F5;
                @QuickSlot_F6.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_F6;
                @QuickSlot_F6.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_F6;
                @QuickSlot_F6.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_F6;
                @QuickSlot_S.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_S;
                @QuickSlot_S.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_S;
                @QuickSlot_S.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_S;
                @QuickSlot_D.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_D;
                @QuickSlot_D.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_D;
                @QuickSlot_D.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_D;
                @QuickSlot_Q.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_Q;
                @QuickSlot_Q.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_Q;
                @QuickSlot_Q.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_Q;
                @QuickSlot_Y.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_Y;
                @QuickSlot_Y.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_Y;
                @QuickSlot_Y.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_Y;
                @QuickSlot_B.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_B;
                @QuickSlot_B.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_B;
                @QuickSlot_B.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_B;
                @QuickSlot_H.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_H;
                @QuickSlot_H.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_H;
                @QuickSlot_H.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_H;
                @QuickSlot_1.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_1;
                @QuickSlot_1.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_1;
                @QuickSlot_1.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_1;
                @QuickSlot_2.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_2;
                @QuickSlot_2.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_2;
                @QuickSlot_2.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_2;
                @QuickSlot_3.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_3;
                @QuickSlot_3.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_3;
                @QuickSlot_3.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_3;
                @QuickSlot_4.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_4;
                @QuickSlot_4.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_4;
                @QuickSlot_4.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_4;
                @QuickSlot_5.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_5;
                @QuickSlot_5.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_5;
                @QuickSlot_5.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_5;
                @QuickSlot_6.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_6;
                @QuickSlot_6.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_6;
                @QuickSlot_6.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_6;
                @QuickSlot_7.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_7;
                @QuickSlot_7.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_7;
                @QuickSlot_7.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_7;
                @QuickSlot_8.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_8;
                @QuickSlot_8.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_8;
                @QuickSlot_8.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_8;
                @QuickSlot_9.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_9;
                @QuickSlot_9.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_9;
                @QuickSlot_9.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_9;
                @QuickSlot_0.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_0;
                @QuickSlot_0.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_0;
                @QuickSlot_0.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_0;
                @QuickSlot_minus.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_minus;
                @QuickSlot_minus.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_minus;
                @QuickSlot_minus.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_minus;
                @QuickSlot_equals.started -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_equals;
                @QuickSlot_equals.performed -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_equals;
                @QuickSlot_equals.canceled -= m_Wrapper.m_QuickSlotsActionsCallbackInterface.OnQuickSlot_equals;
            }
            m_Wrapper.m_QuickSlotsActionsCallbackInterface = instance;
            if (instance != null)
            {
                @QuickSlot_F1.started += instance.OnQuickSlot_F1;
                @QuickSlot_F1.performed += instance.OnQuickSlot_F1;
                @QuickSlot_F1.canceled += instance.OnQuickSlot_F1;
                @QuickSlot_F2.started += instance.OnQuickSlot_F2;
                @QuickSlot_F2.performed += instance.OnQuickSlot_F2;
                @QuickSlot_F2.canceled += instance.OnQuickSlot_F2;
                @QuickSlot_F3.started += instance.OnQuickSlot_F3;
                @QuickSlot_F3.performed += instance.OnQuickSlot_F3;
                @QuickSlot_F3.canceled += instance.OnQuickSlot_F3;
                @QuickSlot_F4.started += instance.OnQuickSlot_F4;
                @QuickSlot_F4.performed += instance.OnQuickSlot_F4;
                @QuickSlot_F4.canceled += instance.OnQuickSlot_F4;
                @QuickSlot_F5.started += instance.OnQuickSlot_F5;
                @QuickSlot_F5.performed += instance.OnQuickSlot_F5;
                @QuickSlot_F5.canceled += instance.OnQuickSlot_F5;
                @QuickSlot_F6.started += instance.OnQuickSlot_F6;
                @QuickSlot_F6.performed += instance.OnQuickSlot_F6;
                @QuickSlot_F6.canceled += instance.OnQuickSlot_F6;
                @QuickSlot_S.started += instance.OnQuickSlot_S;
                @QuickSlot_S.performed += instance.OnQuickSlot_S;
                @QuickSlot_S.canceled += instance.OnQuickSlot_S;
                @QuickSlot_D.started += instance.OnQuickSlot_D;
                @QuickSlot_D.performed += instance.OnQuickSlot_D;
                @QuickSlot_D.canceled += instance.OnQuickSlot_D;
                @QuickSlot_Q.started += instance.OnQuickSlot_Q;
                @QuickSlot_Q.performed += instance.OnQuickSlot_Q;
                @QuickSlot_Q.canceled += instance.OnQuickSlot_Q;
                @QuickSlot_Y.started += instance.OnQuickSlot_Y;
                @QuickSlot_Y.performed += instance.OnQuickSlot_Y;
                @QuickSlot_Y.canceled += instance.OnQuickSlot_Y;
                @QuickSlot_B.started += instance.OnQuickSlot_B;
                @QuickSlot_B.performed += instance.OnQuickSlot_B;
                @QuickSlot_B.canceled += instance.OnQuickSlot_B;
                @QuickSlot_H.started += instance.OnQuickSlot_H;
                @QuickSlot_H.performed += instance.OnQuickSlot_H;
                @QuickSlot_H.canceled += instance.OnQuickSlot_H;
                @QuickSlot_1.started += instance.OnQuickSlot_1;
                @QuickSlot_1.performed += instance.OnQuickSlot_1;
                @QuickSlot_1.canceled += instance.OnQuickSlot_1;
                @QuickSlot_2.started += instance.OnQuickSlot_2;
                @QuickSlot_2.performed += instance.OnQuickSlot_2;
                @QuickSlot_2.canceled += instance.OnQuickSlot_2;
                @QuickSlot_3.started += instance.OnQuickSlot_3;
                @QuickSlot_3.performed += instance.OnQuickSlot_3;
                @QuickSlot_3.canceled += instance.OnQuickSlot_3;
                @QuickSlot_4.started += instance.OnQuickSlot_4;
                @QuickSlot_4.performed += instance.OnQuickSlot_4;
                @QuickSlot_4.canceled += instance.OnQuickSlot_4;
                @QuickSlot_5.started += instance.OnQuickSlot_5;
                @QuickSlot_5.performed += instance.OnQuickSlot_5;
                @QuickSlot_5.canceled += instance.OnQuickSlot_5;
                @QuickSlot_6.started += instance.OnQuickSlot_6;
                @QuickSlot_6.performed += instance.OnQuickSlot_6;
                @QuickSlot_6.canceled += instance.OnQuickSlot_6;
                @QuickSlot_7.started += instance.OnQuickSlot_7;
                @QuickSlot_7.performed += instance.OnQuickSlot_7;
                @QuickSlot_7.canceled += instance.OnQuickSlot_7;
                @QuickSlot_8.started += instance.OnQuickSlot_8;
                @QuickSlot_8.performed += instance.OnQuickSlot_8;
                @QuickSlot_8.canceled += instance.OnQuickSlot_8;
                @QuickSlot_9.started += instance.OnQuickSlot_9;
                @QuickSlot_9.performed += instance.OnQuickSlot_9;
                @QuickSlot_9.canceled += instance.OnQuickSlot_9;
                @QuickSlot_0.started += instance.OnQuickSlot_0;
                @QuickSlot_0.performed += instance.OnQuickSlot_0;
                @QuickSlot_0.canceled += instance.OnQuickSlot_0;
                @QuickSlot_minus.started += instance.OnQuickSlot_minus;
                @QuickSlot_minus.performed += instance.OnQuickSlot_minus;
                @QuickSlot_minus.canceled += instance.OnQuickSlot_minus;
                @QuickSlot_equals.started += instance.OnQuickSlot_equals;
                @QuickSlot_equals.performed += instance.OnQuickSlot_equals;
                @QuickSlot_equals.canceled += instance.OnQuickSlot_equals;
            }
        }
    }
    public QuickSlotsActions @QuickSlots => new QuickSlotsActions(this);

    // Chat
    private readonly InputActionMap m_Chat;
    private IChatActions m_ChatActionsCallbackInterface;
    private readonly InputAction m_Chat_Newaction;
    public struct ChatActions
    {
        private @InputController m_Wrapper;
        public ChatActions(@InputController wrapper) { m_Wrapper = wrapper; }
        public InputAction @Newaction => m_Wrapper.m_Chat_Newaction;
        public InputActionMap Get() { return m_Wrapper.m_Chat; }
        public void Enable() { Get().Enable(); }
        public void Disable() { Get().Disable(); }
        public bool enabled => Get().enabled;
        public static implicit operator InputActionMap(ChatActions set) { return set.Get(); }
        public void SetCallbacks(IChatActions instance)
        {
            if (m_Wrapper.m_ChatActionsCallbackInterface != null)
            {
                @Newaction.started -= m_Wrapper.m_ChatActionsCallbackInterface.OnNewaction;
                @Newaction.performed -= m_Wrapper.m_ChatActionsCallbackInterface.OnNewaction;
                @Newaction.canceled -= m_Wrapper.m_ChatActionsCallbackInterface.OnNewaction;
            }
            m_Wrapper.m_ChatActionsCallbackInterface = instance;
            if (instance != null)
            {
                @Newaction.started += instance.OnNewaction;
                @Newaction.performed += instance.OnNewaction;
                @Newaction.canceled += instance.OnNewaction;
            }
        }
    }
    public ChatActions @Chat => new ChatActions(this);
    public interface IUIActions
    {
        void OnInventory(InputAction.CallbackContext context);
        void OnCharacter(InputAction.CallbackContext context);
        void OnSkills(InputAction.CallbackContext context);
        void OnOptions(InputAction.CallbackContext context);
        void OnGuild(InputAction.CallbackContext context);
        void OnMiniMap(InputAction.CallbackContext context);
        void OnReturn(InputAction.CallbackContext context);
        void OnParty(InputAction.CallbackContext context);
        void OnEscape(InputAction.CallbackContext context);
    }
    public interface IQuickSlotsActions
    {
        void OnQuickSlot_F1(InputAction.CallbackContext context);
        void OnQuickSlot_F2(InputAction.CallbackContext context);
        void OnQuickSlot_F3(InputAction.CallbackContext context);
        void OnQuickSlot_F4(InputAction.CallbackContext context);
        void OnQuickSlot_F5(InputAction.CallbackContext context);
        void OnQuickSlot_F6(InputAction.CallbackContext context);
        void OnQuickSlot_S(InputAction.CallbackContext context);
        void OnQuickSlot_D(InputAction.CallbackContext context);
        void OnQuickSlot_Q(InputAction.CallbackContext context);
        void OnQuickSlot_Y(InputAction.CallbackContext context);
        void OnQuickSlot_B(InputAction.CallbackContext context);
        void OnQuickSlot_H(InputAction.CallbackContext context);
        void OnQuickSlot_1(InputAction.CallbackContext context);
        void OnQuickSlot_2(InputAction.CallbackContext context);
        void OnQuickSlot_3(InputAction.CallbackContext context);
        void OnQuickSlot_4(InputAction.CallbackContext context);
        void OnQuickSlot_5(InputAction.CallbackContext context);
        void OnQuickSlot_6(InputAction.CallbackContext context);
        void OnQuickSlot_7(InputAction.CallbackContext context);
        void OnQuickSlot_8(InputAction.CallbackContext context);
        void OnQuickSlot_9(InputAction.CallbackContext context);
        void OnQuickSlot_0(InputAction.CallbackContext context);
        void OnQuickSlot_minus(InputAction.CallbackContext context);
        void OnQuickSlot_equals(InputAction.CallbackContext context);
    }
    public interface IChatActions
    {
        void OnNewaction(InputAction.CallbackContext context);
    }
}
