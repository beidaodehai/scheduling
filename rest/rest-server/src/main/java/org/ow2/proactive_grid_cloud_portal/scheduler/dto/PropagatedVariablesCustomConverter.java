/*
 * ProActive Parallel Suite(TM):
 * The Open Source library for parallel and distributed
 * Workflows & Scheduling, Orchestration, Cloud Automation
 * and Big Data Analysis on Enterprise Grids & Clouds.
 *
 * Copyright (c) 2007 - 2017 ActiveEon
 * Contact: contact@activeeon.com
 *
 * This library is free software: you can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License
 * as published by the Free Software Foundation: version 3 of
 * the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * If needed, contact us to obtain a release under GPL Version 2 or 3
 * or a different license than the AGPL.
 */
package org.ow2.proactive_grid_cloud_portal.scheduler.dto;

import java.util.HashMap;
import java.util.Map;

import org.dozer.DozerConverter;
import org.ow2.proactive.utils.ObjectByteConverter;


public class PropagatedVariablesCustomConverter extends DozerConverter<Map, Map> {

    public PropagatedVariablesCustomConverter() {
        super(Map.class, Map.class);
    }

    @Override
    public Map convertTo(Map source, Map destination) {
        if (source == null) {
            return null;
        }

        Map<String, byte[]> converted = new HashMap<>();
        for (Map.Entry<String, String> entry : ((Map<String, String>) source).entrySet()) {
            converted.put(entry.getKey(), ObjectByteConverter.base64StringToByteArray(entry.getValue()));
        }
        return converted;
    }

    @Override
    @SuppressWarnings("unchecked")
    public Map convertFrom(Map source, Map destination) {
        if (source == null) {
            return null;
        }
        Map<String, String> converted = new HashMap<>();
        for (Map.Entry<String, byte[]> entry : ((Map<String, byte[]>) source).entrySet()) {
            converted.put(entry.getKey(), ObjectByteConverter.byteArrayToBase64String(entry.getValue()));
        }
        return converted;
    }
}
