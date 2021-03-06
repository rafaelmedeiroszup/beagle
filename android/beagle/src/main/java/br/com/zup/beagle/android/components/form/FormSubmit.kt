/*
 * Copyright 2020 ZUP IT SERVICOS EM TECNOLOGIA E INOVACAO SA
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package br.com.zup.beagle.android.components.form

import android.view.View
import br.com.zup.beagle.android.components.form.core.Constants
import br.com.zup.beagle.android.components.utils.beagleComponent
import br.com.zup.beagle.android.engine.renderer.ViewRendererFactory
import br.com.zup.beagle.android.widget.RootView
import br.com.zup.beagle.android.widget.ViewConvertable
import br.com.zup.beagle.core.BeagleJson
import br.com.zup.beagle.core.GhostComponent
import br.com.zup.beagle.core.ServerDrivenComponent

/**
 * Component will define a submit handler for a form.
 *
 * @param child
 *                  define the submit handler.
 *                  It is generally set as a button to be clicked after a form is filled up.
 * @param enabled
 *                  define as "true" by default and it will enable the button to be clicked on.
 *                  If it is defined as "false" the button will start as "disabled"
 *
 */
@Deprecated(Constants.FORM_DEPRECATED_MESSAGE)
@BeagleJson(name = "formSubmit")
data class FormSubmit(
    override val child: ServerDrivenComponent,
    val enabled: Boolean = true,
) : ViewConvertable, GhostComponent {

    @Transient
    private val viewRendererFactory: ViewRendererFactory = ViewRendererFactory()

    override fun buildView(rootView: RootView): View {
        return viewRendererFactory.make(child).build(rootView).apply {
            beagleComponent = this@FormSubmit
        }
    }
}
