// Copyright (C) 2022 Intel Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions
// and limitations under the License.
//
// SPDX-License-Identifier: Apache-2.0

#include <memory>

#include "cursor.h"
#include "ga-common.h"
#include "encoder-common.h"

// Queue the cursor data into the server
int queue_cursor(const CURSOR_INFO& info, const uint8_t *pBuffer, uint32_t nLen)
{
    std::shared_ptr<CURSOR_DATA> cursorData = std::make_shared<CURSOR_DATA>();
    cursorData->cursorInfo = info;
    if (pBuffer) {
        memcpy(cursorData->cursorData, pBuffer, nLen);
        cursorData->lenOfCursor      = nLen;
        cursorData->cursorDataUpdate = true;
    } else {
        cursorData->cursorDataUpdate = false;
    }
    encoder_send_cursor(cursorData, nullptr);

    return 0;
}
